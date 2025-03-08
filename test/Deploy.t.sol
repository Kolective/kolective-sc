// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../script/Deploy.s.sol";
import "../src/MockToken.sol";
import "../src/TokenFactory.sol";
import "../src/Core.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

contract DeployTest is Test {
    Deploy deployScript;
    TokenFactory factory;
    Core core;
    address[] public tokenAddresses;
    
    function setUp() public {
        deployScript = new Deploy();
        
        // Deploy TokenFactory and Core contracts
        factory = new TokenFactory();
        core = new Core();
    }

    function testDeployment() public {
        deployScript.run();
    }

    function testTokenDeployment() public {
        uint256 wethLiquidity = Math.mulDiv(
            131_000 * 10 ** 18,
            10 ** 18,
            2_719_420000000000000000
        );
        uint256 pepeLiquidity = Math.mulDiv(
            131_000 * 10 ** 18,
            10 ** 18,
            7850000000000
        );

        Deploy.TokenInfo[5] memory tokens = [
            Deploy.TokenInfo(
                "SONIC",
                "S",
                18,
                1_000_000_000 * 10 ** 18,
                131_000 * 10 ** 18
            ),
            Deploy.TokenInfo(
                "USD Coin",
                "USDC",
                6,
                1_000_000_000 * 10 ** 6,
                131_000 * 10 ** 6
            ),
            Deploy.TokenInfo(
                "Tether USD",
                "USDT",
                6,
                1_000_000_000 * 10 ** 6,
                131_000 * 10 ** 6
            ),
            Deploy.TokenInfo(
                "Wrapped Ether",
                "WETH",
                18,
                1_000_000_000 * 10 ** 18,
                wethLiquidity
            ),
            Deploy.TokenInfo(
                "PEPE",
                "PEPE",
                18,
                1_000_000_000 * 10 ** 18,
                pepeLiquidity
            )
        ];

        for (uint256 i = 0; i < tokens.length; i++) {
            address tokenAddress = factory.createToken(
                tokens[i].name,
                tokens[i].symbol,
                tokens[i].initialSupply,
                tokens[i].decimals
            );

            assertTrue(tokenAddress != address(0), "Token deployment failed");
            tokenAddresses.push(tokenAddress);
        }
    }

    function testLiquiditySetup() public {
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            MockToken token = MockToken(tokenAddresses[i]);
            token.approve(address(core), 131_000 * 10 ** 18);
            core.setLiquidity(tokenAddresses[i], 131_000 * 10 ** 18);

            uint256 liquidity = core.liquidity(tokenAddresses[i]);
            assertEq(liquidity, 131_000 * 10 ** 18, "Liquidity setup failed");
        }
    }
}
