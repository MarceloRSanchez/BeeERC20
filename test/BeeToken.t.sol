// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/BeeToken.sol";
import "../src/MultisigWallet.sol";

contract BeeTokenTest is Test {
    BeeToken token;
    MultiSigWallet wallet;

    address Pedro = vm.addr(0x1);
    address Simon = vm.addr(0x2);
    address Marcelo = vm.addr(0x3);
    address[] owners;
    bytes _data;

    function setUp() public {
        token = new BeeToken("BeeToken", "BEE");
        // = [Pedro, Simon, Marcelo];
        owners.push(Pedro);
        owners.push(Simon);
        owners.push(Marcelo);

        wallet = new MultiSigWallet(owners, 2);
    }

    function testTransactionCount() public {
        vm.startPrank(Marcelo);
        //ejecutar transaccion y 
        wallet.submitTransaction(Pedro, 1234, _data);
        assertEq(1, wallet.getTransactionCount());
        vm.stopPrank();
    }

    function testName() public {
        assertEq("BeeToken", token.name());
    }
     function testMint() public {
        token.mint(Pedro, 10000);
        assertEq(token.totalSupply(), token.balanceOf(Pedro));
    }

    function testApprove() public {
        assertTrue(token.approve(Pedro, 5000));
        assertEq(token.allowance(address(this),Pedro), 5000);
    }

    function testTransfer() external {
        testMint();
        vm.startPrank(Pedro);
        token.transfer(Simon, 1000);
        assertEq(token.balanceOf(Simon), 1000);
        assertEq(token.balanceOf(Pedro), 9000);
        vm.stopPrank();
    }

    function testTransferFrom() external {
        testMint();
        vm.prank(Pedro);
        token.approve(address(this), 5000);
        assertTrue(token.transferFrom(Pedro, Simon, 5000));
        assertEq(token.allowance(Pedro, address(this)), 10000 - 5000);
        assertEq(token.balanceOf(Pedro), 10000 - 5000);
        assertEq(token.balanceOf(Simon), 5000);
    }
}
