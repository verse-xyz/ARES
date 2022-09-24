// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

interface ImageTypes {
    struct Image {
        string imageURI;
        address creator;
        bytes32 imageHash;
    }

    struct Config {
        address token;
        string name;
    }
}
