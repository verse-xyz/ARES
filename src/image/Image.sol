// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { IImage } from "../interfaces/IImage.sol";
import { UUPS } from "../proxy/UUPS.sol";
import { Ownable } from "../utils/Ownable.sol";
import { ImageStorage } from "./storage/ImageStorage.sol";
//import { Token } from "../token/Token.sol";


contract Image is IImage, UUPS, Ownable, ImageStorage {
    // this is how we're going to render metadata for a given token
    // each token is going to have a name (common), image, caption, like data hash, comment data hash, creator, and an owner
    // we also need a mirror counter

    // we're going to store the address of the associated hyperobject contract

    /*//////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    // in the initializer we need to specify the hyperobject source and the relevant common data for all NFTs
    constructor() {
    }

    /*//////////////////////////////////////////////////////////////
                            INITIALIZER
    //////////////////////////////////////////////////////////////*/
    /// @notice Initializes a Token's image contract
    /// @param _initStrings The encoded token and metadata initialization strings
    /// @param _token The associated ERC-721 token address
    function initialize(
      bytes calldata _initStrings,
      address _token
    ) external initializer {
      (string memory _name, string memory _symbol) = abi.decode(_initStrings, (string, string));

      config.name = _name;
      config.symbol = _symbol;
      config.token = _token;
    }

    /*//////////////////////////////////////////////////////////////
                            INITIALIZER
    //////////////////////////////////////////////////////////////*/
    // what do we need in this contract?
    // in the knit function the caller passes in the relevant data and then we store it in the tokenInfo mapping
}

// when someone knits, they're gonna pass in the imageURI
// we're gonna store the imageURI in the base mapping
