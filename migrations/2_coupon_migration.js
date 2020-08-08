const couponModify = artifacts.require("couponModify");

module.exports = function (deployer) {
  deployer.deploy(couponModify);
};