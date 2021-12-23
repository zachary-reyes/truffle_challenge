// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    uint256 public startTime;
    uint256 public endTime;
    uint256 public deployedTime;

    constructor(uint256 _startTime, uint256 _endTime) ERC20('Zarface', 'ZAR') {
        startTime = _startTime;
        endTime = _endTime;
        
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    // function _beforeTokenTransfer(address from, address to, uint256 amount) 
    //     internal virtual override
    // {
    //     super._beforeTokenTransfer(from, to, amount);
    //     require(hasStarted() && !hasEnded());    
    // }

    function transfer(address to, uint amount) public override(ERC20) returns (bool){
        require(hasStarted() && !hasEnded());
        super.transfer(to, amount);
        return true;
    }

    function hasStarted() public view returns (bool) {
        return (block.timestamp >= startTime);
    }

    function hasEnded() public view returns (bool) {
        return (block.timestamp >= endTime);
    }

}