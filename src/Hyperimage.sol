// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {IHyperobject} from "./interfaces/IHyperobject.sol";
import {IImage} from "./interfaces/IImage.sol";
import {ERC721} from "./token/ERC721.sol";
import {ReentrancyGuard} from "./utils/ReentrancyGuard.sol";
import {HyperobjectStorage} from "./storage/HyperobjectStorage.sol";

contract Hyperimage is IHyperobject, ERC721, ReentrancyGuard, HyperobjectStorage {
    /*//////////////////////////////////////////////////////////////
                              STORAGE
  //////////////////////////////////////////////////////////////*/

    /// @notice Max reward BPS
    uint16 constant MAX_REWARD_BPS = 50_00;

    /*//////////////////////////////////////////////////////////////
                              CORE FUNCTIONS
  //////////////////////////////////////////////////////////////*/

    function initialize(
        bytes calldata _hyperimageInitData,
        IHyperobject.MarketConfiguration calldata _marketConfig,
        IImage _image
    ) external initializer {
        // Init reentrancy guard
        __ReentrancyGuard_init();

        // Decode the hyperimage token data
        (string memory _name, string memory _symbol,,) =
            abi.decode(_hyperimageInitData, (string, string, string, string));

        // Init ERC-721 Token
        __ERC721_init(_name, _symbol);

        // Set the market configuration
        marketConfig = _marketConfig;

        // Store the image renderer
        image = _image;
    }
}
