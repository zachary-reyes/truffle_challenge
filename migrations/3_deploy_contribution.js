const Contribution = artifacts.require('Contribution');

module.exports = async function (deployer) {
  await deployer.deploy(Contribution);
};
