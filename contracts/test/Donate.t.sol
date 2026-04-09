// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/DonatingMoney.sol";

contract DonatingMoneyTest is Test {
    DonatingMoney donatingMoney;

    address owner;
    address user;

    function setUp() public {
        owner = address(this);
        user = address(1);

        donatingMoney = new DonatingMoney();

        vm.deal(user, 10 ether);
    }

    function testOwnerIsSetCorrectly() public {
        assertEq(donatingMoney.owner(), owner);
    }

    function testFundSuccess() public {
        vm.prank(user);

        donatingMoney.fund{value: 1 ether}();

        assertEq(address(donatingMoney).balance, 1 ether);
    }

    function testFundFailsIfZero() public {
        vm.prank(user);

        vm.expectRevert("Invalid Amount");
        donatingMoney.fund{value: 0}();
    }

    function testWithdrawFailsForNonOwner() public {
        vm.prank(user);

        vm.expectRevert("You are not the owner");
        donatingMoney.withdraw();
    }

    function testWithdrawSuccess() public {
        vm.prank(user);
        donatingMoney.fund{value: 2 ether}();

        uint256 ownerBalanceBefore = owner.balance;

        donatingMoney.withdraw();

        uint256 ownerBalanceAfter = owner.balance;

        assertEq(address(donatingMoney).balance, 0);
        assertEq(ownerBalanceAfter, ownerBalanceBefore + 2 ether);
    }

    function testMultipleFunders() public {
        address user2 = address(2);
        vm.deal(user2, 5 ether);

        vm.prank(user);
        donatingMoney.fund{value: 1 ether}();

        vm.prank(user2);
        donatingMoney.fund{value: 2 ether}();

        assertEq(address(donatingMoney).balance, 3 ether);
    }

    function testWithdrawAllBalance() public {
        vm.prank(user);
        donatingMoney.fund{value: 3 ether}();

        donatingMoney.withdraw();

        assertEq(address(donatingMoney).balance, 0);
    }
}