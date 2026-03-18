/**
 * Bulk upload History questions to Firestore
 *
 * Usage:
 *   1. Download a Firebase service-account key from:
 *      Firebase Console → Project Settings → Service accounts → Generate new private key
 *   2. Save it as  scripts/serviceAccountKey.json
 *   3. Run:
 *        cd scripts
 *        npm install firebase-admin
 *        node upload_questions.js
 *
 *   The script reads history_questions.json and writes every question
 *   to:  subjects/history/parts/{partId}/topics/{topicId}/questions/{autoId}
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

// ── Load questions ───────────────────────────────────────────
const questionsPath = path.join(__dirname, 'history_questions.json');
const data = JSON.parse(fs.readFileSync(questionsPath, 'utf8'));

async function upload() {
  let total = 0;
  const BATCH_LIMIT = 500; // Firestore batch limit

  for (const [partId, topics] of Object.entries(data)) {
    for (const [topicId, questions] of Object.entries(topics)) {
      console.log(`Uploading ${questions.length} questions → history/${partId}/${topicId}`);

      // Process in chunks of BATCH_LIMIT
      for (let i = 0; i < questions.length; i += BATCH_LIMIT) {
        const chunk = questions.slice(i, i + BATCH_LIMIT);
        const batch = db.batch();

        for (const q of chunk) {
          const ref = db
            .collection('subjects')
            .doc('history')
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
        total += chunk.length;
        console.log(`  committed ${Math.min(i + BATCH_LIMIT, questions.length)}/${questions.length}`);
      }
    }
  }

  console.log(`\nDone! Uploaded ${total} questions total.`);
}

upload().catch((err) => {
  console.error('Upload failed:', err);
  process.exit(1);
});
