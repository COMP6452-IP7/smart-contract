const Song = artifacts.require("Song");
const SongStorage = artifacts.require("SongStorage");

module.exports = function (deployer) {
  deployer.deploy(Song);
  deployer.deploy(SongStorage);
};