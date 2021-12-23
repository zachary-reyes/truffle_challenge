// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title My token contract that inherits from OZ's ERC-20 contract
/// @author Zachary A. Reyes
/// @notice Tokens can only be transferred after a particular startTime
///         and before a particular endTime, provided in the constructor
contract MyToken is ERC20 {
    uint256 public startTime;
    uint256 public endTime;

    constructor(uint256 _startTime, uint256 _endTime) ERC20('Zarface', 'ZAR') {
        startTime = _startTime;
        endTime = _endTime;
        
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    /// @notice Override transfer function to only be callable during
    ///         specified time 
    /// @dev Would have used beforeTokenTransfer hook but then wouldn't be 
    ///      be able to premint supply...next time allowing minting from 
    ///      the contributions contract may be a better approach.
    /// @param to Address tokens should be transferred to 
    /// @param amount # of tokens to be transferred
    /// @return True if transfer successful, revert if condition is not met
    function transfer(address to, uint amount) 
      public override(ERC20) returns (bool)
    {
      require(hasStarted() && !hasEnded());
      super.transfer(to, amount);
      return true;
    }

    /// @notice compares call time to startTime
    /// @return True if current time is greatr than or equal to start constraint
    function hasStarted() public view returns (bool) {
        return (block.timestamp >= startTime);
    }

    /// @notice checks call time to endTime
    /// @return True if current time is greater than or equal to end constraint
    function hasEnded() public view returns (bool) {
        return (block.timestamp >= endTime);
    }

}