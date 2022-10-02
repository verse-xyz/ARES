// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { HyperimageTest } from "../Utils/HyperimageTest.sol";

import { IFactory, Factory } from "../../src/factory/Factory.sol";
import { IToken, Token } from "../../src/token/Token.sol";
import { IImage, Image } from "../../src/image/Image.sol";
import { IARES, ARES } from "../../src/market/ARES.sol";

import { TokenTypes } from "../../src/token/types/TokenTypes.sol";

contract TokenTest is HyperimageTest, TokenTypes {
  function setUp() public virtual override {
    super.setUp();
  }

  function testMockTokenInit() public {
    deployMock();
    // initializing parameters are set
    assertEq(token.name(), "Verse");
    assertEq(token.getCreator(), creator);
    assertEq(token.getImage(), address(image));
    assertEq(token.getSupply(), 1);
    assertEq(token.ownerOf(1), creator);
  }

  function testKnit() public {
    deployMock();
    createUsers(3, 100e18);
    address knitter = sampleUsers[0];
    vm.prank(knitter);
    // knit
    token.knit{value: 5e18}("verse.xyz/image");
    assertEq(token.ownerOf(2), knitter);
    assertEq(token.getSupply(), 2);
  }

  function testRevertKnit() public {
    deployMock();
    createUsers(3, 100e18);
    address knitter = sampleUsers[0];
    vm.prank(knitter);
    // knit
    vm.expectRevert(abi.encodeWithSignature("UNDERPAID()"));
    token.knit{value: 3e18}("verse.xyz/image");
  }

  function testMirror() public {
    deployMock();
    createUsers(3, 100e18);
    address knitter = sampleUsers[0];
    address mirrorer = sampleUsers[1];
    vm.prank(knitter);
    // knit
    token.knit{value: 5e18}("verse.xyz/image");
    // mirror
    vm.prank(mirrorer);
    token.mirror{value: 10e18}(0xbe0f0127806aeb66d17b9dbc056a4da57ffff6ba2807bfa7a70eddb7fc50bb38);
  }

  function testRevertMirror_InvalidHash() public {
    deployMock();
    createUsers(3, 100e18);
    address knitter = sampleUsers[0];
    address mirrorer = sampleUsers[1];
    vm.prank(knitter);
    // knit
    token.knit{value: 5e18}("verse.xyz/image");
    // mirror
    vm.prank(mirrorer);
    vm.expectRevert(abi.encodeWithSignature("NONEXISTENT_IMAGE()"));
    // input a random hash that for sure does not exist
    token.mirror{value: 10e18}(0xbe0f0127806aeb66d17b9dbc056a4da57ffff6ba2807bfa7a70eddb7fc50bb39);
  }

  function testRevertMirror_Underpaid() public {
    deployMock();
    createUsers(3, 100e18);
    address knitter = sampleUsers[0];
    address mirrorer = sampleUsers[1];
    vm.prank(knitter);
    // knit
    token.knit{value: 5e18}("verse.xyz/image");
    // mirror
    vm.prank(mirrorer);
    vm.expectRevert(abi.encodeWithSignature("UNDERPAID()"));
    token.mirror{value: 1e18}(0xbe0f0127806aeb66d17b9dbc056a4da57ffff6ba2807bfa7a70eddb7fc50bb38);
  }

  function testBurn() public {
    deployMock();
    createUsers(3, 100e18);
    address knitter = sampleUsers[0];
    vm.startPrank(knitter);
    // knit
    token.knit{value: 5e18}("verse.xyz/image");
    // burn
    token.burn(2);
    vm.stopPrank();
  }

  function testRevertBurn_InvalidId() public {
    deployMock();
    createUsers(3, 100e18);
    address knitter = sampleUsers[0];
    vm.prank(knitter);
    // knit
    token.knit{value: 5e18}("verse.xyz/image");
    vm.expectRevert(abi.encodeWithSignature("ONLY_OWNER()"));
    token.burn(2);
  }

  function testRevertBurn_InvalidOwner() public {
    deployMock();
    createUsers(3, 100e18);
    address knitter = sampleUsers[0];
    address random = sampleUsers[1];
    vm.prank(knitter);
    // knit
    token.knit{value: 5e18}("verse.xyz/image");
    vm.prank(random);
    vm.expectRevert(abi.encodeWithSignature("ONLY_OWNER()"));
    token.burn(2);
  }

  function testRedeem() public {
    deployMock();
    createUsers(3, 100e18);
    address knitter = sampleUsers[0];
    address mirrorer = sampleUsers[1];
    vm.prank(knitter);
    token.knit{value: 5e18}("verse.xyz/image");
    vm.prank(mirrorer);
    token.mirror{value: 10e18}(0xbe0f0127806aeb66d17b9dbc056a4da57ffff6ba2807bfa7a70eddb7fc50bb38);
    vm.prank(creator);
    token.redeem();
  }

  function testRevertRedeem() public {
    deployMock();
    createUsers(3, 100e18);
    address knitter = sampleUsers[0];
    address mirrorer = sampleUsers[1];
    address random = sampleUsers[2];
    vm.prank(knitter);
    token.knit{value: 5e18}("verse.xyz/image");
    vm.prank(mirrorer);
    token.mirror{value: 10e18}(0xbe0f0127806aeb66d17b9dbc056a4da57ffff6ba2807bfa7a70eddb7fc50bb38);
    vm.prank(random);
    vm.expectRevert(abi.encodeWithSignature("ONLY_CREATOR()"));
    token.redeem();
  }

  receive() external payable {}
}