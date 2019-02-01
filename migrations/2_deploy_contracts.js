const ConvertLib = artifacts.require("ConvertLib");
const Tweeder = artifacts.require("Tweeder");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, Tweeder);
  deployer.deploy(Tweeder);
};
