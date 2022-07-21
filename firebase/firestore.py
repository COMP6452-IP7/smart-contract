
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import storage
from mp3hash import mp3hash
import Consts as CONST

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

    print("Added song! URL is " + blob.public_url)

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

def update_song(songName, songFile):
    pass

#initialize_firestore()
add_song("Adele", "someone like you", "./firebase/adele.mp3")
#retrieve_song("Rihanna", "Stay")
