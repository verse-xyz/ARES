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

  function test_MockTokenInit() public {
    deployMock();

    // assertEq(token.name(), "Verse");
    // assertEq(token.getCreator(), creator);
  }
}