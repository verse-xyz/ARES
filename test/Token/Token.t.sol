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
    createUsers(3, 10e18);
    address knitter = sampleUsers[0];
    vm.prank(knitter);
    // knit
    token.knit{value: 5e18}("verse.xyz/image");
    assertEq(token.ownerOf(2), knitter);
    assertEq(token.getSupply(), 2);
  }

  function testRevertKnit() public {
    deployMock();
    createUsers(3, 10e18);
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

  function testRevertMirror() public {
    deployMock();
    createUsers(3, 10e18);
    address knitter = sampleUsers[0];
    address mirrorer = sampleUsers[1];
    vm.prank(knitter);
    // knit
    token.knit{value: 5e18}("verse.xyz/image");
    // mirror
    vm.prank(mirrorer);
    vm.expectRevert(abi.encodeWithSignature("NONEXISTENT_IMAGE()"));
    token.mirror{value: 10e18}(0xbe0f0127806aeb66d17b9dbc056a4da57ffff6ba2807bfa7a70eddb7fc50bb38);
  }

  function testBurn() public {

  }

  function testRevertBurn() public {

  }

  function testRedeem() public {

  }

  function testRevertRedeem() public {

  }

  receive() external payable {}
}