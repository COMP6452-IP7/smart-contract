
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import storage
from mp3hash import mp3hash

#from google.cloud.firestore_v1 import Increment

#from UserProfile import UserProfile
import Consts as CONST
#from TestClient import main

##def initialize_firestore():
# Use a firestore service account
cred = credentials.Certificate("./firebase/ipmanagementmusic.json")
firebase_admin.initialize_app(cred, {'storageBucket': 'ipmanagement-music.appspot.com'})
db = firestore.client()
print("Accessing Firestore")


def add_song(artist, song_name, song_file):

    if song_name == " " or artist == " " or song_file == " ":
        print("Incorrect input!")
        exit

    song_hash = mp3hash(song_file)

    song_name = song_name.title()
    artist = artist.title()

    filename = song_file
    bucket = storage.bucket()
    blob = bucket.blob(filename)
    blob.upload_from_filename(filename)

    data = {
        u'Song Name': song_name,
        u'Artist': artist,
        u'Song File': blob.public_url,
        u'Song Hash': song_hash
    }

    db.collection(artist).document(song_name).set(data)

def retrieve_song(artist, song_name):

    song_name = song_name.title()
    artist = artist.title()

    doc_ref = db.collection(artist).document(song_name)
    doc = doc_ref.get()

    if doc.exists:
        print('Song Information:', doc.to_dict())
    else:
        print('Song does not exist!')
        exit

    # Server to retrieve user info from firestore
    # db.collection(CONST.SONGS).document().set()
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

def update_song(songName, songFile):
    pass

#initialize_firestore()
add_song("Adele", "rolling in the deep", "./firebase/adele.mp3")
#retrieve_song("Stay", "Rihanna")
        
   

    
  