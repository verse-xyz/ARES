// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {IImage} from "../interfaces/IImage.sol";
import {MetadataRenderAdminCheck} from "../metadata/MetadataRenderAdminCheck.sol";
import {NFTMetadataRenderer} from "../utils/NFTMetadataRenderer.sol";
import {IHyperobject} from "../interfaces/IHyperobject.sol";
import {Hyperobject} from "../Hyperobject.sol";
import {IERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC165Upgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {IOwnable} from "../interfaces/IOwnable.sol";
import {OwnableSkeleton} from "../utils/OwnableSkeleton.sol";
import {Version} from "../utils/Version.sol";
import {FactoryUpgradeGate} from "../FactoryUpgradeGate.sol";

contract Image is IImage, UUPSUpgradeable, AccessControlUpgradeable, OwnableSkeleton {
    // this is how we're going to render metadata for a given token
    // each token is going to have a name (common), image, caption, like data hash, comment data hash, creator, and an owner
    // we also need a mirror counter

    struct tokenInfo {
        uint256 tokenId;
        string name;
        string imageURI;
        address creator;
        address owner;
        string likesURI;
        string commentsURI;
    }

    /// @notice Storage for token information from tokenId to tokenInfo
    mapping(uint256 => tokenInfo) public tokenInfos;

    // we're going to store the address of the associated hyperobject contract
    Hyperobject public immutable source;

    // in the initializer we need to specify the hyperobject source and the relevant common data for all NFTs
    constructor(IHyperobject _source) {
        source = Hyperobject(payable(address(_source)));
    }

    // what do we need in this contract?
    // in the knit function the caller passes in the relevant data and then we store it in the tokenInfo mapping
}

// when someone knits, they're gonna pass in the imageURI
// we're gonna store the imageURI in the base mapping
