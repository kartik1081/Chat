
import firebase_admin as admin
from firebase_admin import credentials

cred = credentials.Certificate("C:/Users/kartik/StudioProjects/textme/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

