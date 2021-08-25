// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");
const { auth, messaging, firestore } = require("firebase-admin");
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
  .document("Notifications/{documentId}")
  .onCreate((snapshot, context) => {
    // var rUser = admin.firestore
    // .document(`Users/${snapshot.data()["sendTo"]}`)
    // .get();.
    // var sUser = admin.firestore.document(`User/${snapshot.date()["sendBy"]}).get();
    var message = {
      data: {
        // title: sUser["name"]
        title: "title",
        body: snapshot.data()["msg"],
      },
      // token: rUser["msgToken"]
      token:
        "f6FksBeMS_61AIW9mx9sbC:APA91bHvKAa4IwEjQIoXkb7hVCCmf_F2uftSA7qzsbukOVy2JfPN2ZFacRhBE7h3rQrKlOF69iYhNJ2ZLwje8hNVanlKUmiaNiGYyG97nFNUKRddTb5bCBx8o1Gj-bmb4j784KM_0A3n",
    };
    admin
      .messaging()
      .send(message)
      .then((response) => {
        console.log(`Message send successfully..:  ${response}`);
      });
    return functions.firestore.document("Notifications/{documentId}");
  });
