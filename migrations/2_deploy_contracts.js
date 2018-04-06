const Bank = artifacts.require("Bank");
const Attacker = artifacts.require("Attacker");

module.exports = function(deployer) {
  deployer
    .deploy(Bank)
    .then(() =>
      deployer.deploy(Attacker, Bank.address)
    )
};
