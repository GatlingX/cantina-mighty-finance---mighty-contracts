// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "contracts/AddressRegistry.sol";
import "contracts/libraries/helpers/AddressId.sol";

contract AddressRegistryTest is Test {
    AddressRegistry public addressRegistry;
    address public weth9Mock = address(0x1);
    address public owner;
    address public nonOwner = address(0x2);

    function setUp() public {
        owner = msg.sender;
        addressRegistry = new AddressRegistry(weth9Mock);
    }

    function test_constructor_setsWeth9Address() public {
        assertEq(addressRegistry.getAddress(AddressId.ADDRESS_ID_WETH9), weth9Mock, "WETH9 address should be set in constructor");
    }

    function test_setAddress_byOwner() public {
        address newLendingPoolAddress = address(0x3);
        vm.prank(owner);
        addressRegistry.setAddress(AddressId.ADDRESS_ID_LENDING_POOL, newLendingPoolAddress);
        assertEq(addressRegistry.getAddress(AddressId.ADDRESS_ID_LENDING_POOL), newLendingPoolAddress, "Lending pool address should be updated by owner");
    }

    function test_getAddress() public {
        address newLendingPoolAddress = address(0x4);
        vm.prank(owner);
        addressRegistry.setAddress(AddressId.ADDRESS_ID_LENDING_POOL, newLendingPoolAddress);
        assertEq(addressRegistry.getAddress(AddressId.ADDRESS_ID_LENDING_POOL), newLendingPoolAddress, "Should return the correct address");
    }

    function test_setAddress_byNonOwner_reverts() public {
        address newTreasuryAddress = address(0x5);
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        vm.prank(nonOwner);
        addressRegistry.setAddress(AddressId.ADDRESS_ID_TREASURY, newTreasuryAddress);
    }
}
