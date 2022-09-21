// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { UUPS } from "../proxy/UUPS.sol";
import { ReentrancyGuard } from "../utils/ReentrancyGuard.sol";
import { ERC721 } from "../token/ERC721.sol";
import { TokenStorage } from "./storage/TokenStorage.sol";
import { IToken } from "./interfaces/IToken.sol";
import { IImage } from "../image/interfaces/IImage.sol";
import { Image } from "../image/Image.sol";
import { LinearASTRO } from "../market/LinearASTRO.sol";

import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
import {toDaysWadUnsafe} from "solmate/utils/SignedWadMath.sol";


contract Token is IToken, ERC721, UUPS, ReentrancyGuard, TokenStorage {
  /*//////////////////////////////////////////////////////////////
                          CONSTRUCTOR
  //////////////////////////////////////////////////////////////*/

  /*//////////////////////////////////////////////////////////////
                          INITIALIZER
  //////////////////////////////////////////////////////////////*/
  // we need to use the argu
  function initialize(
    bytes calldata _initStrings,
    address creator,
    uint16 rewardBPS,
    address _image,
    address _market
  ) external initializer {
    __ReentrancyGuard_init();
    (string memory _name, string memory _symbol, string memory _initImageURI) = abi.decode(_initStrings, (string, string, string));
    __ERC721_init(_name, _symbol);
    config.image = _image;
    config.market = _market;
  }

  uint256 public totalMinted;
  uint256 public circulatingSupply;

  uint256 public immutable startTime = block.timestamp;

  /*//////////////////////////////////////////////////////////////
                          FUNCTIONS
  //////////////////////////////////////////////////////////////*/

  function knit(string memory imageURI) public payable returns (uint256 tokenId) {
    unchecked {
      uint256 price = LinearASTRO(config.market).getVRGDAPrice(toDaysWadUnsafe(block.timestamp - startTime), tokenId = totalMinted++);
      circulatingSupply++;
      require(msg.value >= price, "Token: Insufficient payment");
      Image(config.image).knitToken(tokenId, msg.sender, bytes(imageURI));
      _mint(msg.sender, tokenId);
      // Note: We do this at the end to avoid creating a reentrancy vector.
      // Refund the user any ETH they spent over the current price of the NFT.
      // Unchecked is safe here because we validate msg.value >= price above.
      SafeTransferLib.safeTransferETH(msg.sender, msg.value - price);

    }
  }

  function mirror(uint256 mirrorTokenId) public payable returns (uint256 tokenId) {
    unchecked {
      uint256 price = LinearASTRO(config.market).getVRGDAPrice(toDaysWadUnsafe(block.timestamp - startTime), tokenId = totalMinted++);
      circulatingSupply++;
      require(msg.value >= price, "Token: Insufficient payment");
      Image(config.image).mirrorToken(tokenId, mirrorTokenId);
      _mint(msg.sender, tokenId);
      // Note: We do this at the end to avoid creating a reentrancy vector.
      // Refund the user any ETH they spent over the current price of the NFT.
      // Unchecked is safe here because we validate msg.value >= price above.
      SafeTransferLib.safeTransferETH(msg.sender, msg.value - price);
    }
  }

  function burn(uint256 tokenId) public {
    unchecked {
      require(ownerOf(tokenId) == msg.sender, "Token: Not owner");
      uint256 price = LinearASTRO(config.market).getVRGDAPrice(toDaysWadUnsafe(block.timestamp - startTime), circulatingSupply--);
      _burn(tokenId);
      SafeTransferLib.safeTransferETH(msg.sender, price);
    }
  }

  // knit
  // mirror
  // burn
  // creator knit
  // creator mirror

  // we want to give the creator "equity" 
  // that is, they have the right to mint a certain amount of tokens at no cost
  // show the creator how many "free mints" they have left?

}