// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import OpenZeppelin's IERC20
import {IERC20} from "../lib/forge-std/src/interfaces/IERC20.sol";

// Import Uniswap V2 Router Interface
import {IUniswapV2Router02} from "../src/IUniswapV2Router02.sol";

contract TokenSwap {
    address private constant UNISWAP_ROUTER = 0xeE567Fe1712Faf6149d80dA1E6934E354124CfE3;
    IUniswapV2Router02 public uniswapRouter;

    constructor() {
        uniswapRouter = IUniswapV2Router02(UNISWAP_ROUTER);
    }

    function swapTokens(address tokenIn, address tokenOut, uint amountIn, uint amountOutMin, address to) external {
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenIn).approve(UNISWAP_ROUTER, amountIn);
        address[] memory path;
        path = new address[](2);
        path[0] = tokenIn;
        //path[1] = WETH;
        path[1] = tokenOut;


        // Execute the swap
        uniswapRouter.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            block.timestamp + 30 // Deadline: current time + 30 sec
        );
    }

    function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to ) external {
        // Transfer tokens to the contract
        IERC20(tokenA).transferFrom(msg.sender, address(this), amountADesired);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountBDesired);

        // Approve tokens to the Uniswap router
        IERC20(tokenA).approve(UNISWAP_ROUTER, amountADesired);
        IERC20(tokenB).approve(UNISWAP_ROUTER, amountBDesired);

        // Add liquidity
        uniswapRouter.addLiquidity(
            tokenA,
            tokenB,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            to,
            block.timestamp + 30 // Deadline
            );
        }

// Address WETH: 0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14
//Address USDC: 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238

}

