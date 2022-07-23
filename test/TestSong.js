const fs = require('fs')

const Song = artifacts.require("Song.sol");
const Oracle = artifacts.require("Oracle.sol");

contract('Song', function (accounts) {
  let exampleSong, oracle;
  let expirationDate = new Date();
  expirationDate.setFullYear(expirationDate.getFullYear() + 70);

  it("get an instance of Oracle contract", function() {
    return Oracle.deployed()
      .then(instance => {
        oracle = instance;
        assert(oracle, "Oracle contract is not deployed");
      })
  });

  // Deploy the example song contract by artist (accounts[0])
  beforeEach(async function () {
    const songFileContents = fs.readFileSync('./adele.mp3').toString()
    songFileHash = web3.utils.keccak256(songFileContents);
    exampleSong = await Song.new(
      "Oh My God", // title
      songFileHash, // fileHash
      Math.floor(expirationDate.getTime() / 1000), // expirationDate
      Song.LicenseType.MasterLicense, // licenseType
      "Adele",
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
    await exampleSong.modifySongLicense(Song.LicenseType.SyncLicense, {from: accounts[0]});
    const songInformation2 = await exampleSong.getSongInformation.call();
    expect(songInformation2.license).to.equal(Song.LicenseType.SyncLicense.toString());
  });

  it('Give user licensing', async function () {
    await exampleSong.giveUserLicensing(accounts[1], {from: accounts[0]});
    await exampleSong.giveUserLicensing(accounts[2], {from: accounts[0]});
    const account1Lisence = await exampleSong.getUserLicensing.call(accounts[1]);
    const account2Lisence = await exampleSong.getUserLicensing.call(accounts[2]);
    expect(parseInt(account1Lisence)).to.equal(Song.LicenseType.MasterLicense);
    expect(parseInt(account2Lisence)).to.equal(Song.LicenseType.MasterLicense);
  });

  it('Check artist alive', async function () {
    const artistAlive = await exampleSong.stillAlive.call(oracle);
    expect(artistAlive).to.equal(true);
  });

});

