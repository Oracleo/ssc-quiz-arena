/**
 * Delete ALL questions from Firestore for every subject/part/topic
 *
 * Iterates through every subject → part → topic → questions subcollection
 * and deletes all question documents in batches.
 *
 * Usage:
 *   cd scripts
 *   node delete_all_questions.js
 */

const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const BATCH_LIMIT = 500;

async function deleteCollection(collectionRef) {
  let deleted = 0;

  while (true) {
    const snapshot = await collectionRef.limit(BATCH_LIMIT).get();
    if (snapshot.empty) break;

    const batch = db.batch();
    snapshot.docs.forEach((doc) => batch.delete(doc.ref));
    await batch.commit();
    deleted += snapshot.size;
  }

  return deleted;
}

// Explicit structure matching subjects_data.dart
const STRUCTURE = {
  history:   { prehistory: ['paleolithic','mesolithic','neolithic'], ancient: ['indus','vedic'], medieval: ['delhi_sultanate','mughals'], modern: ['british_rule','freedom'] },
  geography: { physical: ['rivers','mountains'], human: ['agriculture'] },
  polity:    { constitution: ['preamble','fundamental_rights'], government: ['parliament'] },
  economy:   { basics: ['gdp','banking'] },
  science:   { physics: ['motion','light'], chemistry: ['basic_chemistry'] },
  maths:     { arithmetic: ['percentage','profit_loss'], algebra: ['basic_algebra'] },
  english:   { grammar: ['tenses','vocabulary'] },
  reasoning: { verbal: ['analogy','series'], nonverbal: ['coding'] },
  computer:  { basics: ['hardware','internet'] },
  current:   { general_awareness: ['awards','science_tech'] },
};

async function main() {
  let grandTotal = 0;

  for (const [subjectId, parts] of Object.entries(STRUCTURE)) {
    console.log(`\n🗑  Processing subject: ${subjectId}`);

    for (const [partId, topics] of Object.entries(parts)) {
      for (const topicId of topics) {
        const questionsRef = db
          .collection('subjects').doc(subjectId)
          .collection('parts').doc(partId)
          .collection('topics').doc(topicId)
          .collection('questions');

        const count = await deleteCollection(questionsRef);
        grandTotal += count;

        if (count > 0) {
          console.log(`  Deleted ${count} questions from ${subjectId}/${partId}/${topicId}`);
        }
      }
    }
  }

  console.log(`\n✅ Done! Deleted ${grandTotal} questions total.`);
}

main().catch((err) => {
  console.error('Delete failed:', err);
  process.exit(1);
});
