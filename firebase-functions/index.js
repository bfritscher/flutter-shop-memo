/**
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
const {initializeApp} = require("firebase-admin/app");
const {onRequest} = require("firebase-functions/v2/https");
const {onDocumentDeleted} = require("firebase-functions/v2/firestore");
const {getStorage} = require("firebase-admin/storage");
const {getFirestore} = require("firebase-admin/firestore");
const logger = require("firebase-functions/logger");

initializeApp();

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started?gen=2nd
// https://firebase.google.com/docs/storage/admin/start
// https://firebase.google.com/docs/reference/admin/node/firebase-admin.storage

exports.onSnapDeleted = onDocumentDeleted("snaps/{snapId}", (event) => {
  const snapshot = event.data;
  const data = snapshot.data();
  const bucket = getStorage().bucket();
  const file = bucket.file(data.fileRef);
  return file.delete().then(() => {
    logger.info(`Deleted file ${data.fileRef}`);
  });
});

// generate static page
// could be a spa with realtime data to firestore
exports.snap = onRequest(async (req, res) => {
  const snapshot = await getFirestore()
      .collection("snaps")
      .get();
  const posts = snapshot.docs.map((doc) => `<div
  class="post"
  style="background-image:url('${doc.get("url")}')">
  <h2>${doc.get("title")}</h2></div>`);
  res.send(`
    <!doctype html>
    <head>
      <title>Snap!</title>
      <style>
        body {
            margin: 0;
            padding: 0;
        }
        h1 {
            font-family: sans-serif;
            text-align: center;
        }
        .posts {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        }
        .post {
            background-size: cover;
            background-position: center;
            height: 300px;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 1rem;
            color: white;
            font-family: sans-serif;
        }
      </style>
    </head>
    <body>
      <h1>Welcome to Snap!</h1>
        <div class="posts">
            ${posts.join("\n")}
        </div>
    </body>
  </html>`);
});

