/**
 * Upload ALL subject questions to Firestore
 *
 * Reads every {subject}_questions.json from scripts/questions/
 * and uploads to: subjects/{subjectId}/parts/{partId}/topics/{topicId}/questions/{autoId}
 *
 * Usage:
 *   cd scripts
 *   npm install firebase-admin
 *   node upload_all_questions.js
 */

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// ── Firebase init ────────────────────────────────────────────
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// ── Subject list (matches subjects_data.dart) ────────────────
const SUBJECTS = [
  'history',
  'geography',
  'polity',
  'economy',
  'science',
  'maths',
  'english',
  'reasoning',
  'computer',
  'current',
];

const BATCH_LIMIT = 500;

async function uploadSubject(subjectId) {
  const filePath = path.join(__dirname, 'questions', `${subjectId}_questions.json`);

  if (!fs.existsSync(filePath)) {
    console.log(`⚠  Skipping ${subjectId}: file not found`);
    return 0;
  }

  const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
  let subjectTotal = 0;

  for (const [partId, topics] of Object.entries(data)) {
    for (const [topicId, questions] of Object.entries(topics)) {
      console.log(`  ${subjectId}/${partId}/${topicId} → ${questions.length} questions`);

      for (let i = 0; i < questions.length; i += BATCH_LIMIT) {
        const chunk = questions.slice(i, i + BATCH_LIMIT);
        const batch = db.batch();

        for (const q of chunk) {
          const ref = db
            .collection('subjects')
            .doc(subjectId)
            .collection('parts')
            .doc(partId)
            .collection('topics')
            .doc(topicId)
            .collection('questions')
            .doc(); // auto-ID

          batch.set(ref, {
            q: q.q,
            opts: q.opts,
            ans: q.ans,
          });
        }

        await batch.commit();
        subjectTotal += chunk.length;
      }
    }
  }

  return subjectTotal;
}

async function main() {
  let grandTotal = 0;

  for (const subjectId of SUBJECTS) {
    console.log(`\n📘 Uploading ${subjectId}...`);
    const count = await uploadSubject(subjectId);
    grandTotal += count;
    console.log(`  ✅ ${subjectId}: ${count} questions uploaded`);
  }

  console.log(`\n🎉 Done! Uploaded ${grandTotal} questions across ${SUBJECTS.length} subjects.`);
}

main().catch((err) => {
  console.error('Upload failed:', err);
  process.exit(1);
});
