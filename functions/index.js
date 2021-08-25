// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");
const { auth, messaging } = require("firebase-admin");
admin.initializeApp();

exports.helloWorld = functions.https.onRequest((re, res) => {
  res.send("Hello from firebase function...");
});

exports.userCreated = functions.auth.user().onCreate((user) => {
  console.log(`${user.email} is created...`);
  return "created..";
});
exports.userDeleted = functions.auth.user().onDelete((user) => {
  console.log(`${user.email} is deleted...`);
  return "deleted";
});

exports.sentMSG = functions.firestore
  .document(`Chats/${uid}/{collectionId}/{documentId}`)
  .onCreate((snapshot, context) => {
    console.log(snapshot.data());
    return Promise.resolve;
  });
