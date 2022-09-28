// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { HyperimageTest } from "../Utils/HyperimageTest.sol";

import { IFactory, Factory } from "../../factory/Factory.sol";
import { IToken, Token } from "../../token/Token.sol";
import { IImage, Image } from "../../image/Image.sol";
import { IARES, ARES } from "../../market/ARES.sol";

import { TokenTypes } from "../../token/types/TokenTypes.sol";

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