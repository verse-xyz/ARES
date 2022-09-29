// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { HyperimageTest } from "../Utils/HyperimageTest.sol";

import { IFactory, Factory } from "../../src/factory/Factory.sol";
import { IToken, Token } from "../../src/token/Token.sol";
import { IImage, Image } from "../../src/image/Image.sol";
import { IARES, ARES } from "../../src/market/ARES.sol";

import { ImageTypes } from "../../src/image/types/ImageTypes.sol";

contract ImageTest is HyperimageTest, ImageTypes {
  function setUp() public virtual override {
    super.setUp();
  }

  function test_MockImageInit() public {
    deployMock();
    assertEq(image.name(), "Verse");
    assertEq(image.token(), address(token));
  }



}