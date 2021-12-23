const Contributions = artifacts.require('Contributions');

module.exports = async function (deployer) {
  await deployer.deploy(Contributions);
};
