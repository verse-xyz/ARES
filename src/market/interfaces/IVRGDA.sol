// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title IVRGDA
/// @author neuroswish
/// @notice The external VRGDA events, errors, and functions

interface IVRGDA {
  /*//////////////////////////////////////////////////////////////
                              ERRORS
  //////////////////////////////////////////////////////////////*/

  /// @dev Reverts if a decay constant is non-negative
  error NON_NEGATIVE_DECAY_CONSTANT();

  /*//////////////////////////////////////////////////////////////
                              FUNCTIONS
  //////////////////////////////////////////////////////////////*/

  /// @notice Calculate the price of a token according to the VRGDA formula.
  /// @param timeSinceStart Time passed since the VRGDA began, scaled by 1e18.
  /// @param sold The total number of tokens that have been sold so far.
  /// @return The price of a token according to VRGDA, scaled by 1e18.
  function getVRGDAPrice(int256 timeSinceStart, uint256 sold) external view returns (uint256);

  /// @dev Given a number of tokens sold, return the target time that number of tokens should be sold by.
  /// @param sold A number of tokens sold, scaled by 1e18, to get the corresponding target sale time for.
  /// @return The target time the tokens should be sold by, scaled by 1e18, where the time is
  /// relative, such that 0 means the tokens should be sold immediately when the VRGDA begins.
  function getTargetSaleTime(int256 sold) external view returns (int256);
}