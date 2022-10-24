// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "forge-std/Script.sol";
import { IFactory, Factory } from "../src/factory/Factory.sol";
import { IToken, Token } from "../src/token/Token.sol";
import { IImage, Image } from "../src/image/Image.sol";
import { UniversalImageStorage } from "../src/image/storage/UniversalImageStorage.sol";

contract CreateScript is Script {
  IFactory.TokenParams internal tokenParams;

  function setMockTokenParams() internal virtual {
    setTokenParams(
      "Verse",
      "verse.xyz",
      1e18,
      0.33e18,
      1e18
    );
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

  function run() external {
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployerPrivateKey);

    //address factoryImpl = address(new Factory());

    Factory factory = Factory(0x0eF9f82D527b5d02bD2433e66253C686Db770C33);
    

    vm.stopBroadcast();
  }
}