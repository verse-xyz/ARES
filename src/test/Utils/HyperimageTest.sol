// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { Test } from "forge-std/Test.sol"; 

import { IFactory, Factory } from "../../factory/Factory.sol";
import { IToken, Token } from "../../token/Token.sol";
import { IUniversalImageStorage, UniversalImageStorage } from "../../image/storage/UniversalImageStorage.sol";
import { IImage, Image } from "../../image/Image.sol";
import { IARES, ARES } from "../../market/ARES.sol";

contract HyperimageTest is Test {
  /*//////////////////////////////////////////////////////////////
                            BASE SETUP
  //////////////////////////////////////////////////////////////*/

  Factory internal factory;

  address internal factoryImpl;
  address internal tokenImpl;
  address internal imageImpl;
  address internal universalImageStorage;

  address internal creator;
  address internal verse;

  function setUp() public virtual {
    creator = vm.addr(0xA11CE);
    verse = vm.addr(0xB0B);

    vm.label(creator, "CREATOR");
    vm.label(verse, "VERSE");

    factoryImpl = address(new Factory());
    factory = Factory(factoryImpl);

    tokenImpl = address(new Token(address(factory)));
    universalImageStorage = address(new UniversalImageStorage(address(factory)));
    imageImpl = address(new Image(address(factory), address(universalImageStorage)));

    vm.prank(verse);
    factory.initialize(tokenImpl, imageImpl, universalImageStorage);

  }

  /*//////////////////////////////////////////////////////////////
                          HYPERIMAGE CUSTOMIZATION UTILS
  //////////////////////////////////////////////////////////////*/

  IFactory.TokenParams internal tokenParams;

  function setMockTokenParams() internal virtual {

  }

  function setTokenParams(
    string memory _name,
    string memory _initImageURI,
    int256 _targetPrice,
    int256 _priceDecayPercent,
    int256 _perTimeUnit
  ) internal virtual {
    bytes memory initStrings = abi.encode(_name, _initImageURI);
    tokenParams = IFactory.TokenParams({
      initStrings: initStrings,
      targetPrice: _targetPrice,
      priceDecayPercent: _priceDecayPercent,
      perTimeUnit: _perTimeUnit
    }); 
  }
}