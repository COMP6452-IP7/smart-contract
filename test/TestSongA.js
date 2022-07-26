const fs = require('fs')

const Song = artifacts.require("Song.sol");
const Oracle = artifacts.require("Oracle.sol");

const oracleAddress = fs.readFileSync('./oracle_address.txt', 'utf8');

// The expiration date of the songs is set to the current time + 20 years
let expirationDate = new Date();
expirationDate.setFullYear(expirationDate.getFullYear() + 20);
let expirationTime = Math.floor(expirationDate.getTime() / 1000);

// Example song information
let songInfo = {
  title: "Oh My God",
  artist: "Adele",
  file: "./files/OhMyGod.mp3",
  expirationTime: expirationTime,
  license: Song.LicenseType.MasterLicense
}
songFileHash = web3.utils.keccak256(fs.readFileSync(songInfo.file).toString());

// Interact with Song contract
contract("SongAlive", function (accounts) {
  let exampleSong, oracle;

  it("Get an instance of Oracle contract", function () {
    return Oracle.deployed()
      .then(instance => {
        oracle = instance;
        assert(oracle, "Oracle contract is not deployed");
      })
  });

  // Deploy the example song's contract by artist (accounts[0])
  beforeEach(async function () {
    exampleSong = await Song.new(
      songInfo.title,
      songFileHash,
      songInfo.expirationTime,
      songInfo.license,
      songInfo.artist,
      accounts[0]
    );
  });

  it('Read song information', async function () {
    const songInformation1 = await exampleSong.getSongInformation.call();
    expect(songInformation1.title).to.equal("Oh My God");
    expect(songInformation1.fileHash).to.equal(songFileHash);
    expect(songInformation1.expirationDate).to.equal(Math.floor(expirationDate.getTime() / 1000).toString());
    expect(songInformation1.license).to.equal(Song.LicenseType.MasterLicense.toString());
    expect(songInformation1.artistName).to.equal("Adele");
    expect(songInformation1.artistAddress).to.equal(accounts[0]);
  });

  it('Modify song license', async function () {
    await exampleSong.modifySongLicense(Song.LicenseType.SyncLicense, { from: accounts[0] });
    const songInformation2 = await exampleSong.getSongInformation.call();
    expect(songInformation2.license).to.equal(Song.LicenseType.SyncLicense.toString());
  });

  it('Give user licensing', async function () {
    await exampleSong.giveUserLicensing(accounts[1], { from: accounts[0] });
    await exampleSong.giveUserLicensing(accounts[2], { from: accounts[0] });
    const account1License = await exampleSong.getUserLicensing.call(accounts[1], oracleAddress);
    const account2License = await exampleSong.getUserLicensing.call(accounts[2], oracleAddress);
    const account3License = await exampleSong.getUserLicensing.call(accounts[3], oracleAddress);
    expect(parseInt(account1License)).to.equal(Song.LicenseType.MasterLicense);
    expect(parseInt(account2License)).to.equal(Song.LicenseType.MasterLicense);
    expect(parseInt(account3License)).to.equal(Song.LicenseType.NoLicense);
  });

  it('Check artist alive', async function () {
    await exampleSong.updateIsAlive(oracleAddress);
    const artistAlive = await exampleSong.checkAlive.call(oracleAddress);
    expect(artistAlive).to.equal(true);
  });

});
