const Tweeder = artifacts.require("Tweeder");
const TweederCore = artifacts.require("TweederCore");
const TweederCoin = artifacts.require("TweederCoin");

module.exports = function(deployer) {
  deployer.deploy(TweederCoin);
  deployer.link(TweederCoin,Tweeder);
  deployer.deploy(TweederCore);
  deployer.link(TweederCore,Tweeder);
  deployer.deploy(Tweeder);
};
