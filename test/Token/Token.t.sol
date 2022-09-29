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
    address sampleUser = sampleUsers[0];
    vm.prank(sampleUser);
    // knit
    token.knit{value: 5e18}("verse.xyz/image");
    assertEq(token.ownerOf(2), sampleUser);
  }

  function testRevertKnit() public {

  }

  function testMirror() public {

  }

  function testRevertMirror() public {

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