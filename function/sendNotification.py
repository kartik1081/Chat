
import firebase_admin as admin
from firebase_admin import credentials,messaging,firestore,auth
import firebase_admin

cred = credentials.Certificate("C:/Users/kartik/StudioProjects/textme/serviceAccountKey.json")
admin.initialize_app(cred)

def pushNoti(title, msg, token, dataObject=None):

    db = admin.firestore.collection("Users").doc(auth.UserInfo.uid).get()
    message = messaging.MulticastMessage(
        notification=messaging.Notification(
            title=db["name"],
            body=db["email_phone"]
        ),
        data=dataObject,
        tokens=token,
    )

    # send a message to the device corresponding to the provided
    # registration token.
    response = messaging.send.multicast(message)
    # response is a messsage ID string.
    print("Successfully sent message", response)