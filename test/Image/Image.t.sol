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

  function testRevertKnitToken() public {
    deployMock();
    createUsers(3, 100e18);
    address random = sampleUsers[0];
    vm.startPrank(random);
    vm.expectRevert(abi.encodeWithSignature("ONLY_TOKEN()"));
    image.knitToken(1, random, "verse.xyz/image");
    vm.stopPrank();
  }

  function testRevertMirrorToken() public {
    deployMock();
    createUsers(3, 100e18);
    address random = sampleUsers[0];
    vm.startPrank(random);
    vm.expectRevert(abi.encodeWithSignature("ONLY_TOKEN()"));
    image.mirrorToken(1, 0xbe0f0127806aeb66d17b9dbc056a4da57ffff6ba2807bfa7a70eddb7fc50bb38);
    vm.stopPrank();
  }

  function testRevertBurnToken() public {
    deployMock();
    createUsers(3, 100e18);
    address random = sampleUsers[0];
    vm.startPrank(random);
    vm.expectRevert(abi.encodeWithSignature("ONLY_TOKEN()"));
    image.burnToken(1);
    vm.stopPrank();
  }


}