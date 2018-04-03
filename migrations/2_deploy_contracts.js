//var Lotto = artifacts.require("Lotto");
var MillionPixels = artifacts.require("MillionPixels");

module.exports = function(deployer) {
  deployer.deploy(MillionPixels);
};
