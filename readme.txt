SETTING UP

1. Launch Ganache and create a new workspace. Setup the server by setting the port number to 7545.
2. Run the oracle script, index.ts, and obtain the oracle addressing using the command: npx tsc && node build/index.ts
3. Add the Firebase admin SDK using the command: pip install firebase-admin

UPLOADING A SONG

1. Open the Remix IDE and connect to the Ganache network.
2. Deploy Song.sol on Remix - fill in the song information and copy the oracle address that was printed after running the oracle script.
3. Run the song hashing tool, SongFileHashes.js, using the command: truffle test tools/SongFileHashes.js
4. Run the Firebase storage tool, firestore.py, as follows: python3 firestore.py add "Artist Name" "Song Name" "Song File" "Song Hash" "Song File Token" 
   The song information used here must be the same as the information used to deploy Song.sol.

DOWNLOADING A SONG

1. Open the Remix IDE and connect to the Ganache network.
2. Use getSongInformation to retrieve information about a song.
3. Use getSongFileToken to obtain a fileToken for the song (as an authorised user).
4. Run the Firebase storage tool, firestore.py, as follows using the song fileToken obtained above: python3 firestore.py retrieve "Artist Name" "Song File Token"

RUNNING TRUFFLE UNIT TESTS

1. Deploy Song.sol using the same song information used in test/TestSongA.js or test/TestSongB.js
2. Run the truffle test using one of the following commands: "truffle test test/TestSongA.js" or "truffle test test/TestSongB.js"

A SUMMARY OF INTERACTIONS WITH THE SMART CONTRACT

- Use getSongInformation to retrieve information about a song, such as its title, the artist's name and more.
- Use modifySongLicense as an artist to change the LicenseType of a song.
- Use giveUserLicensing as an artist to provide licensing, or usage rights, to a user. Use the user's address as input.
- Use getUserLicensing to obtain information about the licensing rights of a particular user.
- Use getSongFileToken to obtain a fileToken for the song as an authorised user.
- Use updateIsAlive to prompt the oracle to retrieve information externally about whether an artist is alive.
- Use checkAlive to check if the artist is alive.