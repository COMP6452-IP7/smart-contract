
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import storage
import os, sys

# Use a firestore service account
cred = credentials.Certificate("./tools/ipmanagementmusic.json")
firebase_admin.initialize_app(cred, {'storageBucket': 'ipmanagement-music.appspot.com'})
db = firestore.client()
print("Accessing Firestore")

# add song to firestore, generating a public url for the song
def add_song(artist, song_name, song_file, song_hash, file_token):

    if song_name == " " or artist == " " or song_file == " ":
        print("Incorrect input!")
        exit

    song_name = song_name.title()
    artist = artist.title()

    filename = os.path.basename(song_file)
    bucket = storage.bucket()
    blob = bucket.blob(filename)
    blob.upload_from_filename(song_file)

    data = {
        u'Song Name': song_name,
        u'Artist': artist,
        u'Song File': blob.public_url,
        u'Song Hash': song_hash,
        u'Song File Token': file_token,
    }

    db.collection(artist).document(file_token).set(data)

    print("Added song! URL is " + blob.public_url)

# retrieve song from firestore
def retrieve_song(artist, file_token):

    artist = artist.title()

    doc_ref = db.collection(artist).document(file_token)

    doc = doc_ref.get()

    if doc.exists:
        print('Song Information:', doc.to_dict())
    else:
        print('Song does not exist!')
        exit


def update_song(songName, songFile):
    pass


# Usage:
# python3 firestore.py add "Artist Name" "Song Name" "Song File" "Song Hash" "Song File Token"
# python3 firestore.py retrieve "Artist Name" "Song File Token"

if (len(sys.argv) < 2):
    print("Too few arguments!")
    exit
if (sys.argv[1] == 'add' and len(sys.argv) == 7):
    add_song(sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6])
elif (sys.argv[1] == 'retrieve' and len(sys.argv) == 4):
    retrieve_song(sys.argv[2], sys.argv[3])
else:
    print("Wrong arguments!")
    exit
