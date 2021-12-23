//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import './MyToken.sol';

/// @title users can donate ETH and receive ZAR token in exchange
/// @author Zachary A. Reyes
/// @notice If ETH is donated before or after the time lock determined in
///         MyToken contract, the transfer function will revert 
contract Contribution {
    mapping(address => uint) public balances;
    MyToken public token;

    constructor(address _myToken) {
        token = MyToken(_myToken);
    }
    
    /// @notice transfer function dependent on start and end time contraints 
    ///         specified in MyToken constructor
    /// @dev Would have used beforeTokenTransfer hook but then wouldn't be 
    ///      be able to premint supply...next time allowing minting from 
    ///      the contributions contract may be a better approach.
    receive() external payable {
        uint ethDonated = msg.value;
        uint myTokenBalance = token.balanceOf(address(token));
        require(ethDonated > 0, "You need to send some ether");
        require(ethDonated <= myTokenBalance, "Not enough tokens in the reserve");
        token.transfer(msg.sender, ethDonated);
        balances[msg.sender] += ethDonated; ///or just equals??
    }
    
    /// @notice accepts wallet address and returns amount of ETH donated 
    /// @param contributor address of contributor allows us to query balances
    function amountDonated(address contributor) public view returns (uint){
        return balances[contributor];
    }    
}