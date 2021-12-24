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

    event Minted();

    constructor(uint256 _startTime, uint256 _endTime) ERC20('Zarface', 'ZAR') {
        startTime = _startTime;
        endTime = _endTime;
    }

    /// @notice allow users to mint ZAR token
    /// @param account that tokens should be transferred to
    /// @param amount to be transferred to account
    function mint(address account, uint256 amount) public {
        _mint(account, amount);
        emit Minted();
    }

    /// @notice checks start and end time constraints before any transfers
    /// @param from zero address, as specified in ERC20 _mint()
    /// @param to address specified in mint()
    /// @param amount specified in mint()
    function _beforeTokenTransfer(address from, address to, uint256 amount) 
      internal virtual override
    {
      super._beforeTokenTransfer(from, to, amount);
      require(hasStarted() && !hasEnded());    
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