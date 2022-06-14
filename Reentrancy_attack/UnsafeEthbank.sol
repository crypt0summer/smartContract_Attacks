// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "hardhat/console.sol";

contract UnsafeEthbank {

    mapping(address => uint) balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        require(balances[msg.sender] > 0, "Withdrawl amount exceeds available balance.");
        
        console.log("");
        console.log("EtherBank balance: ", address(this).balance);
        console.log("Attacker balance: ", balances[msg.sender]);
        console.log("");

        (bool success, ) = payable(msg.sender).call{value: balances[msg.sender]}(""); // At this point, the caller's code is executed, and can call withdrawBalance again
        require(success);
        balances[msg.sender] = 0;
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}