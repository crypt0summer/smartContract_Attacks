// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "hardhat/console.sol";

contract SafeEthbank3 {
    mapping(address => uint) balances;
    bool private lockBalances;
    
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        require(!lockBalances && balances[msg.sender] > 0 ,"Withdrawl amount exceeds available balance.");
        lockBalances = true;

        console.log("");
        console.log("EtherBank balance: ", address(this).balance);
        console.log("Attacker balance: ", balances[msg.sender]);
        console.log("");

        (bool success, ) = payable(msg.sender).call{value: balances[msg.sender]}(""); 
        if (success) { // Normally insecure, but the mutex saves it
            balances[msg.sender] = 0;
        }
        lockBalances = false;
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}