const ConvertLib = artifacts.require("ConvertLib");
const Tweeder = artifacts.require("Tweeder");
const TweederCore = artifacts.require("TweederCore");
const TweederCoin = artifacts.require("TweederCoin");
module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, TweederCoin);
  deployer.deploy(TweederCoin);
  deployer.link(TweederCoin,Tweeder);
  deployer.deploy(TweederCore);
  deployer.link(TweederCore,Tweeder);
  deployer.deploy(Tweeder);
};
