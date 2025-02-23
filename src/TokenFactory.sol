// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";

contract MockToken is ERC20, Ownable {
    uint256 public price; // Harga token dalam wei (1 token = X wei)
    uint256 public marketCap; // Kapitalisasi pasar dalam wei
    uint256 public liquidity; // Likuiditas dalam wei

    event PriceUpdated(uint256 newPrice);
    event MarketCapUpdated(uint256 newMarketCap);
    event LiquidityUpdated(uint256 newLiquidity);

    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        address owner
    ) ERC20(name, symbol) Ownable(owner) {
        _mint(owner, initialSupply * 10 ** decimals());
        price = 1 ether; // Default 1 token = 1 ETH (mock)
        marketCap = totalSupply() * price;
        liquidity = totalSupply() / 2;
    }

    function setPrice(uint256 newPrice) external onlyOwner {
        price = newPrice;
        marketCap = totalSupply() * newPrice;
        emit PriceUpdated(newPrice);
    }

    function setMarketCap(uint256 newMarketCap) external onlyOwner {
        marketCap = newMarketCap;
        emit MarketCapUpdated(newMarketCap);
    }

    function setLiquidity(uint256 newLiquidity) external onlyOwner {
        liquidity = newLiquidity;
        emit LiquidityUpdated(newLiquidity);
    }

    function getTokenValue(uint256 amount) external view returns (uint256) {
        return amount * price;
    }
}
