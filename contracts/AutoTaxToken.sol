// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AutoTaxToken is ERC20, Ownable {

    uint256 public taxPercent = 5;
    uint256 public burnPercent = 2;
    address public treasury;

    constructor(
        uint256 initialSupply,
        address treasuryWallet
    ) ERC20("Auto Tax Token", "ATT") {
        require(treasuryWallet != address(0), "Invalid treasury");

        treasury = treasuryWallet;
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {

        uint256 taxAmount = (amount * taxPercent) / 100;
        uint256 burnAmount = (amount * burnPercent) / 100;
        uint256 treasuryAmount = taxAmount - burnAmount;
        uint256 sendAmount = amount - taxAmount;

        if (burnAmount > 0) {
            _burn(from, burnAmount);
        }

        if (treasuryAmount > 0) {
            super._transfer(from, treasury, treasuryAmount);
        }

        super._transfer(from, to, sendAmount);
    }

    function updateTax(uint256 newTax, uint256 newBurn) external onlyOwner {
        require(newTax <= 10, "Tax too high");
        require(newBurn <= newTax, "Burn exceeds tax");

        taxPercent = newTax;
        burnPercent = newBurn;
    }

    function updateTreasury(address newTreasury) external onlyOwner {
        require(newTreasury != address(0), "Invalid address");
        treasury = newTreasury;
    }
}
