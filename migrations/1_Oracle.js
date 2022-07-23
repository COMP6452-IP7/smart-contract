// This migration should not be run - the contracts are deployed by src/index.ts

const Oracle = artifacts.require("Oracle");

module.exports = function (deployer) {
  deployer.deploy(Oracle);
};