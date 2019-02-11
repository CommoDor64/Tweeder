const Migrations = artifacts.require("Migrations");
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));

module.exports = function(deployer) {
  web3.eth.personal.unlockAccount("0x06dba49eff058f910d35cc16d50ba4015b35b1ce", "666ykd666", 3600);
  deployer.deploy(Migrations);
};
