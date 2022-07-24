const execSync = require("child_process").execSync;
const fs = require('fs')

const Song = artifacts.require("Song.sol");
const Oracle = artifacts.require("Oracle.sol");

let expirationDate = new Date();
expirationDate.setFullYear(expirationDate.getFullYear() + 70);
let expirationTime = Math.floor(expirationDate.getTime() / 1000);

let songA = {
  title: "Oh My God",
  artist: "Adele",
  file: "./files/OhMyGod.mp3",
  expirationTime: expirationTime,
  license: Song.LicenseType.MasterLicense
}

let songB = {
  title: "Someone Like You",
  artist: "Adele",
  file: "./files/SomeoneLikeYou.mp3",
  expirationTime: expirationTime,
  license: Song.LicenseType.MasterLicense
}

// Upload song files to Firebase
console.log(execSync(`python ./firebase/firestore.py add "${songA.artist}" "${songA.title}" "${songA.file}"`, {
  stdio: "inherit",
  shell: true,
}));

console.log(execSync(`python ./firebase/firestore.py add "${songB.artist}" "${songB.title}" "${songB.file}"`, {
  stdio: "inherit",
  shell: true,
}));

// Interact with Song contract
contract("Song", function (accounts) {
  let exampleSongA, exampleSongB, oracle;

  it("get an instance of Oracle contract", function () {
    return Oracle.deployed()
      .then(instance => {
        oracle = instance;
        assert(oracle, "Oracle contract is not deployed");
      })
  });

  // Deploy the example song A's contract by artist (accounts[0])
  beforeEach(async function () {
    songAFileHash = web3.utils.keccak256(fs.readFileSync(songA.file).toString());
    exampleSongA = await Song.new(
      songA.title,
      songAFileHash,
      songA.expirationTime,
      songA.license,
      songA.artist,
      accounts[0]
    );
  });

  // Deploy the example song B's contract by artist (accounts[0])
  beforeEach(async function () {
    songBFileHash = web3.utils.keccak256(fs.readFileSync(songB.file).toString());
    exampleSongB = await Song.new(
      songB.title,
      songBFileHash,
      songB.expirationTime,
      songB.license,
      songB.artist,
      accounts[0]
    );
  });

  it('Read song information', async function () {
    const songInformation1 = await exampleSongA.getSongInformation.call();
    expect(songInformation1.title).to.equal("Oh My God");
    expect(songInformation1.fileHash).to.equal(songAFileHash);
    expect(songInformation1.expirationDate).to.equal(Math.floor(expirationDate.getTime() / 1000).toString());
    expect(songInformation1.license).to.equal(Song.LicenseType.MasterLicense.toString());
    expect(songInformation1.artistName).to.equal("Adele");
    expect(songInformation1.artistAddress).to.equal(accounts[0]);
  });

  it('Modify song license', async function () {
    await exampleSongA.modifySongLicense(Song.LicenseType.SyncLicense, { from: accounts[0] });
    const songInformation2 = await exampleSongA.getSongInformation.call();
    expect(songInformation2.license).to.equal(Song.LicenseType.SyncLicense.toString());
  });

  it('Give user licensing', async function () {
    await exampleSongA.giveUserLicensing(accounts[1], { from: accounts[0] });
    await exampleSongA.giveUserLicensing(accounts[2], { from: accounts[0] });
    const account1Lisence = await exampleSongA.getUserLicensing.call(accounts[1]);
    const account2Lisence = await exampleSongA.getUserLicensing.call(accounts[2]);
    expect(parseInt(account1Lisence)).to.equal(Song.LicenseType.MasterLicense);
    expect(parseInt(account2Lisence)).to.equal(Song.LicenseType.MasterLicense);
  });

  it('Check artist alive', async function () {
    const artistAlive = await exampleSongA.stillAlive.call(oracle);
    expect(artistAlive).to.equal(true);
  });

});

