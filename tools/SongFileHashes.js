const execSync = require("child_process").execSync;
const fs = require('fs')

// Example song information
let songInfoA = {
  title: "Oh My God",
  artist: "Adele",
  file: "./files/OhMyGod.mp3",
}
let songInfoB = {
  title: "Thriller",
  artist: "Michael Jackson",
  file: "./files/Thriller.mp3",
}

songFileHashA = web3.utils.keccak256(fs.readFileSync(songInfoA.file).toString());
songFileHashB = web3.utils.keccak256(fs.readFileSync(songInfoB.file).toString());

console.log(" > Song A file hash: " + songFileHashA);
console.log(" > Song B file hash: " + songFileHashB);
