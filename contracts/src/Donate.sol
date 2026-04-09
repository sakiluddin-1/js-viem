// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DonatingMoney {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }
    
    function fund() external payable {
        require(msg.value > 0, "Invalid Amount");
    }

    function withdraw() external onlyOwner {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Failed to send Ether");
    }
}