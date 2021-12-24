const { accounts, contract } = require('@openzeppelin/test-environment');
const {expectRevert, time, ether, send, expectEvent} = require('@openzeppelin/test-helpers');
const { BN } = require('@openzeppelin/test-helpers/src/setup');
const { expect, should, assert } = require('chai');
const MyToken = contract.fromArtifact('MyToken');
const Contribution = contract.fromArtifact('Contribution');

describe('My Tests', () => {
  let myToken, startTime, endTime, contribution;
  const [ owner, user ] = accounts;
  let ethToSend = ether('10');

  beforeEach(async () => {
    startTime = (await time.latest()).add(time.duration.hours(1))
    endTime = (await time.latest()).add(time.duration.hours(2))
    myToken = await MyToken.new(startTime, endTime, {from: owner})
    contribution = await Contribution.new(myToken.address)
  })

  describe('When deployed', () => {
    it('should not have started', async () => {
      expect(await myToken.hasStarted()).to.be.false
    })
    it('should not have ended', async () => {
      expect(await myToken.hasEnded()).to.be.false
    })
    it('should not transfer tokens before start time', async () => {
      await expectRevert.unspecified(myToken.mint(user, ethToSend, { from: owner }));
    })
    it('should not allow contributions by user', async () => {
      await expectRevert.unspecified(send.ether(user, contribution.address, ethToSend))
    })
  })

  describe('When enough time has elapsed to start the contract', () => {
    beforeEach(async () => {
      await time.increaseTo(startTime.add(time.duration.seconds(1)))
    })
    it('should have started', async () => {
      expect(await myToken.hasStarted()).to.be.true
    })
    it('should not have ended', async () => {
      expect(await myToken.hasEnded()).to.be.false
    })
    it('should transfer tokens between start and end time', async () => {
      expect(await myToken.mint(user, ethToSend, { from: owner }))
    })
    it('should allow contributions by user', async () => {
      send.ether(user, contribution.address, ethToSend)
    })
  })

  describe('When enough time has elapsed to end the contract', () => {
    beforeEach(async () => {
      await time.increaseTo(endTime.add(time.duration.seconds(1)))
    })
    it('should have started', async () => {
      expect(await myToken.hasStarted()).to.be.true
    })
    it('should have ended', async () => {
      expect(await myToken.hasEnded()).to.be.true
    })
    it('should not transfer tokens after end time', async () => {
      await expectRevert.unspecified(myToken.mint(user, ethToSend, { from: owner }))
    })
    it('should not allow contributions by user', async () => {
      await expectRevert.unspecified(send.ether(user, contribution.address, ethToSend))
    })
  })
})