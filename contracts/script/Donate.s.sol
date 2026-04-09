// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/DonatingMoney.sol";

contract DonatingMoneyScript is Script {
    function run() external {
        vm.startBroadcast();

        DonatingMoney donatingMoney = new DonatingMoney();

        vm.stopBroadcast();
    }
}