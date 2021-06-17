// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


contract MegaBar is ERC20("MegaBar", "xMEGA"){
    using SafeMath for uint256;
    IERC20 public mega;

    constructor(IERC20 _mega) public {
        mega = _mega;
    }

    // Enter the bar. Pay some MEGAs. Earn some shares.
    function enter(uint256 _amount) public {
        uint256 totalMega = mega.balanceOf(address(this));
        uint256 totalShares = totalSupply();
        if (totalShares == 0 || totalMega == 0) {
            _mint(msg.sender, _amount);
        } else {
            uint256 what = _amount.mul(totalShares).div(totalMega);
            _mint(msg.sender, what);
        }
        mega.transferFrom(msg.sender, address(this), _amount);
    }

    // Leave the bar. Claim back your MEGAs.
    function leave(uint256 _share) public {
        uint256 totalShares = totalSupply();
        uint256 what = _share.mul(mega.balanceOf(address(this))).div(totalShares);
        _burn(msg.sender, _share);
        mega.transfer(msg.sender, what);
    }
}
