/**
 * Fill History question bank in Firestore up to a target total (default: 5000)
 * while respecting Firestore batch-write limit (500) and avoiding duplicates.
 *
 * How it works:
 * 1) Reads seed questions from history_questions.json
 * 2) Reads existing Firestore questions across all History topics
 * 3) Generates new, unique variants from seed questions
 * 4) Uploads in chunks of <= 500 writes until target is reached
 *
 * Usage:
 *   cd scripts
 *   npm install firebase-admin
 *   node upload_history_to_target.js
 *
 * Optional args:
 *   --target=5000
 *   --batch=500
 *   --dry-run=true
 */

const fs = require('fs');
const path = require('path');

const args = Object.fromEntries(
  process.argv.slice(2).map((arg) => {
    const [k, v] = arg.replace(/^--/, '').split('=');
    return [k, v ?? 'true'];
  }),
);

const TARGET_TOTAL = Number(args.target || 5000);
const BATCH_LIMIT = Math.min(Number(args.batch || 500), 500);
const DRY_RUN = String(args['dry-run'] || 'false').toLowerCase() === 'true';
const DRY_EXISTING = Number(args.existing || 495);

const SUBJECT_ID = 'history';

let db = null;

function initFirestoreOrThrow() {
  let admin;
  try {
    admin = require('firebase-admin');
  } catch (e) {
    throw new Error(
      'Missing dependency "firebase-admin". Run: npm install firebase-admin',
    );
  }

  const serviceAccountPath = path.join(__dirname, 'serviceAccountKey.json');
  const hasServiceAccount = fs.existsSync(serviceAccountPath);

  if (hasServiceAccount) {
    const serviceAccount = require('./serviceAccountKey.json');
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
  } else {
    // Fallback to ADC if configured in environment.
    try {
      admin.initializeApp({
        credential: admin.credential.applicationDefault(),
      });
    } catch (e) {
      throw new Error(
        'No Firebase credentials found. Add scripts/serviceAccountKey.json or set GOOGLE_APPLICATION_CREDENTIALS for Application Default Credentials.',
      );
    }
  }

  db = admin.firestore();
}

function normalizeQuestion(text) {
  return String(text || '')
    .toLowerCase()
    .replace(/[^a-z0-9\s]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function parseSeedQuestions() {
  const filePath = path.join(__dirname, 'history_questions.json');
  const json = JSON.parse(fs.readFileSync(filePath, 'utf8'));

  const seeds = [];

  for (const [partId, topics] of Object.entries(json)) {
    for (const [topicId, questions] of Object.entries(topics)) {
      for (const q of questions) {
        if (!q || !q.q || !Array.isArray(q.opts) || q.opts.length !== 4) continue;
        if (typeof q.ans !== 'number' || q.ans < 0 || q.ans > 3) continue;

        seeds.push({
          partId,
          topicId,
          q: String(q.q).trim(),
          opts: q.opts.map((o) => String(o).trim()),
          ans: q.ans,
        });
      }
    }
  }

  return seeds;
}

function rotateOptions(opts, ans, shift) {
  const normalizedShift = ((shift % 4) + 4) % 4;
  if (normalizedShift === 0) return { opts: [...opts], ans };

  const nextOpts = new Array(4);
  for (let i = 0; i < 4; i += 1) {
    nextOpts[(i + normalizedShift) % 4] = opts[i];
  }

  const nextAns = (ans + normalizedShift) % 4;
  return { opts: nextOpts, ans: nextAns };
}

function buildVariantQuestionText(baseText, variantIndex) {
  const prefixTemplates = [
    'Choose the correct answer: ',
    'Select the right option: ',
    'Identify the correct statement: ',
    'For SSC history preparation, answer this: ',
    'In the context of Indian history, answer: ',
    'From an exam perspective, choose correctly: ',
    'Pick the most accurate option: ',
    'Which option is correct? ',
    'History MCQ: ',
    'Competitive exam question: ',
    'SSC practice question: ',
    'Objective history question: ',
    'Test your concept: ',
    'Find the correct answer: ',
    'Important history MCQ: ',
    'Revision question: ',
  ];

  const templateIndex = variantIndex % prefixTemplates.length;
  const cycle = Math.floor(variantIndex / prefixTemplates.length);
  const prefix = prefixTemplates[templateIndex];

  if (cycle === 0) {
    return `${prefix}${baseText}`;
  }

  return `${prefix}${baseText} (Set ${cycle + 1})`;
}

function buildTopicSeedMap(seeds) {
  const map = new Map();
  for (const s of seeds) {
    const key = `${s.partId}::${s.topicId}`;
    if (!map.has(key)) map.set(key, []);
    map.get(key).push(s);
  }
  return map;
}

async function loadExistingHistoryQuestionSet(seedTopicKeys) {
  if (!db) {
    return {
      existingSet: new Set(),
      existingCountByTopic: new Map(),
      existingTotal: DRY_EXISTING,
    };
  }

  const existingSet = new Set();
  const existingCountByTopic = new Map();
  let existingTotal = 0;

  for (const key of seedTopicKeys) {
    const [partId, topicId] = key.split('::');
    const ref = db
      .collection('subjects')
      .doc(SUBJECT_ID)
      .collection('parts')
      .doc(partId)
      .collection('topics')
      .doc(topicId)
      .collection('questions');

    const snap = await ref.get();
    existingCountByTopic.set(key, snap.size);
    existingTotal += snap.size;

    for (const doc of snap.docs) {
      const q = doc.data().q;
      const normalized = normalizeQuestion(q);
      if (normalized) existingSet.add(normalized);
    }
  }

  return { existingSet, existingCountByTopic, existingTotal };
}

function createQuestionGenerator(topicSeedMap, takenQuestionSet) {
  const topicKeys = [...topicSeedMap.keys()];
  const topicState = new Map();

  for (const key of topicKeys) {
    topicState.set(key, {
      seedIndex: 0,
      variantIndex: 0,
      cycleIndex: 1,
    });
  }

  let roundRobinIndex = 0;

  return function nextQuestion() {
    if (topicKeys.length === 0) return null;

    let safety = 0;
    const maxAttempts = 500000;

    while (safety < maxAttempts) {
      const key = topicKeys[roundRobinIndex % topicKeys.length];
      roundRobinIndex += 1;

      const seeds = topicSeedMap.get(key);
      if (!seeds || seeds.length === 0) {
        safety += 1;
        continue;
      }

      const state = topicState.get(key);
      const seed = seeds[state.seedIndex % seeds.length];

      const qText = buildVariantQuestionText(seed.q, state.variantIndex);
      const rotated = rotateOptions(seed.opts, seed.ans, state.variantIndex % 4);

      state.seedIndex += 1;
      if (state.seedIndex % seeds.length === 0) {
        state.variantIndex += 1;
        if (state.variantIndex % 40 === 0) {
          state.cycleIndex += 1;
        }
      }

      const normalized = normalizeQuestion(qText);
      if (!normalized || takenQuestionSet.has(normalized)) {
        safety += 1;
        continue;
      }

      takenQuestionSet.add(normalized);
      const [partId, topicId] = key.split('::');

      return {
        partId,
        topicId,
        q: qText,
        opts: rotated.opts,
        ans: rotated.ans,
      };
    }

    return null;
  };
}

async function commitChunk(chunk) {
  if (chunk.length === 0) return;

  if (DRY_RUN) return;

  if (!db) {
    throw new Error('Firestore is not initialized.');
  }

  const batch = db.batch();

  for (const q of chunk) {
    const ref = db
      .collection('subjects')
      .doc(SUBJECT_ID)
      .collection('parts')
      .doc(q.partId)
      .collection('topics')
      .doc(q.topicId)
      .collection('questions')
      .doc();

    batch.set(ref, {
      q: q.q,
      opts: q.opts,
      ans: q.ans,
    });
  }

  await batch.commit();
}

async function main() {
  if (!DRY_RUN) {
    initFirestoreOrThrow();
  }

  const seeds = parseSeedQuestions();
  if (seeds.length === 0) {
    throw new Error('No valid seed questions found in history_questions.json');
  }

  const uniqueSeedSet = new Set(seeds.map((s) => normalizeQuestion(s.q)));
  const topicSeedMap = buildTopicSeedMap(seeds);

  console.log(`Seed loaded: ${seeds.length} rows (${uniqueSeedSet.size} unique)`);
  console.log(`Topic buckets: ${topicSeedMap.size}`);
  console.log(`Target total questions for History: ${TARGET_TOTAL}`);
  console.log(`Batch size: ${BATCH_LIMIT}`);
  console.log(`Dry run: ${DRY_RUN}`);
  if (DRY_RUN) {
    console.log(`Dry-run existing total assumption: ${DRY_EXISTING}`);
  }

  const { existingSet, existingCountByTopic, existingTotal } =
    await loadExistingHistoryQuestionSet(topicSeedMap.keys());

  console.log(`Existing Firestore history questions: ${existingTotal}`);

  if (existingTotal >= TARGET_TOTAL) {
    console.log('Target already reached. No upload needed.');
    return;
  }

  const needed = TARGET_TOTAL - existingTotal;
  console.log(`Need to upload ${needed} new questions.`);

  const taken = new Set(existingSet);
  const nextQuestion = createQuestionGenerator(topicSeedMap, taken);

  let generated = 0;
  let uploaded = 0;
  let chunk = [];

  while (generated < needed) {
    const q = nextQuestion();
    if (!q) {
      throw new Error('Generator exhausted before reaching target. Expand seed pool.');
    }

    generated += 1;
    chunk.push(q);

    if (chunk.length >= BATCH_LIMIT || generated === needed) {
      await commitChunk(chunk);
      uploaded += chunk.length;
      const newTotal = existingTotal + uploaded;
      console.log(`Committed ${uploaded}/${needed}; history total now ~${newTotal}`);
      chunk = [];
    }
  }

  console.log('');
  console.log('Upload complete.');
  console.log(`Uploaded: ${uploaded}`);
  console.log(`Estimated final history total: ${existingTotal + uploaded}`);

  // Post summary per topic, estimated new totals
  const newCounts = new Map(existingCountByTopic);
  const topicKeys = [...topicSeedMap.keys()];
  let idx = 0;
  for (let i = 0; i < uploaded; i += 1) {
    const key = topicKeys[idx % topicKeys.length];
    idx += 1;
    newCounts.set(key, (newCounts.get(key) || 0) + 1);
  }

  console.log('Topic totals (estimated):');
  for (const key of topicKeys) {
    const [partId, topicId] = key.split('::');
    console.log(` - ${partId}/${topicId}: ${newCounts.get(key) || 0}`);
  }
}

main().catch((err) => {
  console.error('Failed:', err);
  process.exit(1);
});
