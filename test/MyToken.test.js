const { accounts, contract } = require('@openzeppelin/test-environment');
const {expectRevert, time } = require('@openzeppelin/test-helpers');
const { expect, should } = require('chai');
const MyToken = contract.fromArtifact('MyToken');

describe('MyToken', () => {
  let tt, startTime, endTime;
  const [ owner, user ] = accounts;

  beforeEach(async () => {
    startTime = (await time.latest()).add(time.duration.hours(1))
    endTime = (await time.latest()).add(time.duration.hours(2))
    tt = await MyToken.new(startTime, endTime, {from: owner})
  })

  describe('When deployed', () => {
    it('should not have started', async () => {
      expect(await tt.hasStarted()).to.be.false
    })
    it('should not have ended', async () => {
      expect(await tt.hasEnded()).to.be.false
    })
    it('should not transfer tokens before start time', async () => {
      await expectRevert.unspecified(tt.transfer(user, 1, { from: owner }));
    })
  })

  describe('When enough time has elapsed to start the contract', () => {
    beforeEach(async () => {
      await time.increaseTo(startTime.add(time.duration.seconds(1)))
    })
    it('should have started', async () => {
      expect(await tt.hasStarted()).to.be.true
    })
    it('should not have ended', async () => {
      expect(await tt.hasEnded()).to.be.false
    })
    it('should transfer tokens between start and end time', async () => {
      expect(await tt.transfer(user, 1, { from: owner }))
    })
  })

  describe('When enough time has elapsed to end the contract', () => {
    beforeEach(async () => {
      await time.increaseTo(endTime.add(time.duration.seconds(1)))
    })
    it('should have started', async () => {
      expect(await tt.hasStarted()).to.be.true
    })
    it('should have ended', async () => {
      expect(await tt.hasEnded()).to.be.true
    })
    it('should not transfer tokens after end time', async () => {
      await expectRevert.unspecified(tt.transfer(user, 1, { from: owner }))
    })
  })
})