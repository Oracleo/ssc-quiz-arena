// Fetch current Firestore security rules
const admin = require('firebase-admin');
const sa = require('./serviceAccountKey.json');
admin.initializeApp({ credential: admin.credential.cert(sa) });

async function getRules() {
  const { GoogleAuth } = require('google-auth-library');
  const auth = new GoogleAuth({
    keyFile: './serviceAccountKey.json',
    scopes: ['https://www.googleapis.com/auth/firebase.readonly', 'https://www.googleapis.com/auth/cloud-platform'],
  });
  const client = await auth.getClient();
  const t = await client.getAccessToken();

  const resp = await fetch(
    `https://firebaserules.googleapis.com/v1/projects/${sa.project_id}/rulesets?pageSize=1`,
    { headers: { Authorization: `Bearer ${t.token}` } }
  );
  const data = await resp.json();

  if (data.rulesets && data.rulesets[0]) {
    const name = data.rulesets[0].name;
    const ruleResp = await fetch(
      `https://firebaserules.googleapis.com/v1/${name}`,
      { headers: { Authorization: `Bearer ${t.token}` } }
    );
    const rules = await ruleResp.json();
    if (rules.source && rules.source.files) {
      rules.source.files.forEach((f) => {
        console.log(`=== ${f.name} ===`);
        console.log(f.content);
      });
    }
  } else {
    console.log('Response:', JSON.stringify(data, null, 2));
  }
}

getRules()
  .then(() => process.exit(0))
  .catch((e) => {
    console.error(e.message);
    process.exit(1);
  });
