
import firebase_admin
import self as self

from firebase_admin import credentials
from firebase_admin import firestore
#from google.cloud.firestore_v1 import Increment

#from UserProfile import UserProfile
import Consts as CONST
#from TestClient import main


def initialize_firestore():
    # Use a firestore service account
    cred = credentials.Certificate(CONST.FIRESTORE_ACCOUNT_KEY)
    firebase_admin.initialize_app(cred)
    db = firestore.client()
    print("Accessing firestore")

    #client send hashed song file with mp3 file to here
    data = {
        u'name': u'brisbane',
        u'state': u'CA',
        u'country': u'USA'
    }
    db.collection(u'cities').document(u'syd').set(data)


def set_song(self,hash, songId):
    # Server to retrieve user info from firestore
        self.db.collection(CONST.SONGS).document().set()
    # seems to sometimes not load in time so user is none
    # Check document exists
    #if user_doc.exists:
        #user = user_doc.to_dict()
        # Get DOB
        #dob = datetime.datetime.strptime(user[CONST.DOB][:len("YYYY-MM-DD")], "%Y-%m-%d").date()
        # Get mini profile picture if exists
        #mini_profile_pic = None
        #if CONST.MINI_PROFILE_PIC in user:
            #mini_profile_pic = user[CONST.MINI_PROFILE_PIC]
        # Return a UserProfile object for server to use

        #return UserProfile(user[CONST.NAME], user[CONST.GENDER], dob, firestore_id, user[CONST.AVATAR_ID],
                            #user[CONST.PREFERENCES], websocket, mini_profile_pic)

    #print("Error - No such document")



#def add_friend(self, user_id, friend):
    #self.db.collection(CONST.USERS).document(user_id).collection(CONST.CONTACTS).document(friend.id). \
        #set(document_data={CONST.NAME: friend.name,
                            #CONST.AVATAR_ID: friend.avatar_id,
                            #CONST.IS_FRIEND: True},
            #merge=True)


initialize_firestore()
#set_song("aaaaa", "001")

        
   

    
  