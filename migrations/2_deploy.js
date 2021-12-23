const MyToken = artifacts.require('MyToken');

module.exports = async function (deployer) {
  endTime = Date.now();
  await deployer.deploy(MyToken, endTime);
};