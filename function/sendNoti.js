
var admin = require("firebase-admin");

var serviceAccount = require("C:/Users/kartik/StudioProjects/textme/serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

var registrationToken = "fJVH_WuDR1WXZyd5_NKpH-:APA91bEsWaroeD5y_0eZeYy4z1UAPNCOnuV5ruBRcj39inpzvBVB19lG4p93GCFLAWjUBG-71yCHKMGbKRQZcyEyi5KOXd06gzx-VuLf2cfwd358XHV5mifRolLqLvQCKo3nmVGXasvw"

var message = {
    data: {
        title: "Hello",
        body: "Looking Goog..."
    },
    token: registrationToken
}

// Send a message to the device corresponding to the provided
// registration token.
admin.messaging().send(message).then((response)=> {
    //Response is a message ID string.
    console.log("Successfully sent message:", response);
}).catch((error)=>{
    console.log("Error sending message:",error);
});