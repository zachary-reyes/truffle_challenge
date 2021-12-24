//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import './MyToken.sol';

/// @title users can donate ETH and receive ZAR token in exchange
/// @author Zachary A. Reyes
/// @notice If ETH is donated before or after the time lock determined in
///         MyToken contract, the mint function will revert 
contract Contribution {
    mapping(address => uint) public balances;
    MyToken public token;

    event Payed();

    constructor(address _myToken) {
        token = MyToken(_myToken);
    }
    
    /// @notice swap ZAR tokens for ETH
    /// @dev beforeTokenTransfer() from MyToken checks time lock first
    receive() external payable {
        uint ethDonated = msg.value;
        require(ethDonated > 0, "You need to send some ether");
        token.mint(msg.sender, ethDonated);
        balances[msg.sender] += ethDonated; 
        emit Payed();
    }
    
    /// @notice accepts wallet address and returns amount of ETH donated 
    /// @param contributor address of contributor allows us to query balances
    function amountDonated(address contributor) public view returns (uint){
        return balances[contributor];
    }    
}