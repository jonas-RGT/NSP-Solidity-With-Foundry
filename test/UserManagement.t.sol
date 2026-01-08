//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/UserManagement.sol";

contract UserManagementTest is Test {
    UserManagement public userManagement;
    address public alice;
    address public bob;

    function setUp() public {
        userManagement = new UserManagement();
        alice = address(0x1);
        bob = address(0x2);
    }

    // Test 1: Register a user
    function testRegisterUser() public {
        vm.prank(alice);
        userManagement.registerUser("Alice");

        (string memory name,, UserManagement.UserStatus status, bool exists) = userManagement.getUser(alice);

        assertEq(name, "Alice");
        assertEq(uint256(status), uint256(UserManagement.UserStatus.Active));
        assertTrue(exists);
    }

    // Test 2: Cannot register with empty name
    function testCannotRegisterEmptyName() public {
        vm.prank(alice);
        vm.expectRevert("Name cannot be empty");
        userManagement.registerUser("");
    }

    // Test 3: Cannot register twice
    function testCannotRegisterTwice() public {
        vm.startPrank(alice);
        userManagement.registerUser("Alice");

        vm.expectRevert("User already registered");
        userManagement.registerUser("Alice");
        vm.stopPrank();
    }

    // Test 4: Update user status (self-service)
    function testUpdateUserStatus() public {
        // Register first
        vm.prank(alice);
        userManagement.registerUser("Alice");

        // Update status as the same user
        vm.prank(alice);
        userManagement.updateUserStatus(UserManagement.UserStatus.Suspended);

        (,, UserManagement.UserStatus status,) = userManagement.getUser(alice);
        assertEq(uint256(status), uint256(UserManagement.UserStatus.Suspended));
    }

    // Test 5: Cannot update non-existent user
    function testCannotUpdateNonExistentUser() public {
        vm.prank(alice);
        vm.expectRevert("User doesn't exist");
        userManagement.updateUserStatus(UserManagement.UserStatus.Banned);
    }

    // Test 6: Multiple users can register
    function testMultipleUsers() public {
        vm.prank(alice);
        userManagement.registerUser("Alice");

        vm.prank(bob);
        userManagement.registerUser("Bob");

        (string memory name1,,, bool exists1) = userManagement.getUser(alice);
        (string memory name2,,, bool exists2) = userManagement.getUser(bob);

        assertEq(name1, "Alice");
        assertEq(name2, "Bob");
        assertTrue(exists1);
        assertTrue(exists2);
    }

   
}
