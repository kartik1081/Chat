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

    if (snapshot.data()["room"] == null) {
      var message = {
        data: {
          // title: sUser["name"]
          title: "title",
          body: snapshot.data()["msg"],
        },
        // token: rUser["msgToken"]
        token: snapshot.data()["token"],
      };

      admin
        .messaging()
        .send(message)
        .then((response) => {
          console.log(`Message send successfully..:  ${response}`);
        });
    } else {
    }

    return functions.firestore.document("Notifications/{documentId}");
  });
