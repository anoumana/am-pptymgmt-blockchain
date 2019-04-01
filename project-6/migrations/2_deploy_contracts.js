// migrating the appropriate contracts
var PptyMgrRole = artifacts.require("./PptyMgrRole.sol");
var AptOwnerRole = artifacts.require("./RentalOwnerRole.sol");
var CleaningCompRole = artifacts.require("./CleaningCompRole.sol");
var ConsumerRole = artifacts.require("./RenterRole.sol");
var SupplyChain = artifacts.require("./SupplyChain.sol");

module.exports = function(deployer) {
  deployer.deploy(PptyMgrRole);
  deployer.deploy(AptOwnerRole);
  deployer.deploy(CleaningCompRole);
  deployer.deploy(ConsumerRole);
  deployer.deploy(SupplyChain);
};
