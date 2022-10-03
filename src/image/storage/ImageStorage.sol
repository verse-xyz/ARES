// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {ImageTypes} from "src/image/types/ImageTypes.sol";

/// @title ImageStorage
/// @author neuroswish
/// @notice The image storage contract
contract ImageStorage is ImageTypes {
    /// @notice Image config
    Config internal config;

    /// @notice The image attributes for a token
    mapping(uint256 => Image) internal tokenToImage;

}
