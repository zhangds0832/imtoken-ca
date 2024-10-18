// SPDX-License-Identifier: MIT
// Experience is priceless.
pragma solidity >=0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract IMAI is ERC20, Ownable {
    event BuyIMAI(address indexed spender, uint256 value);

    uint256 public rateAI = 50000; // （1BNB = 50000 AI）
    uint256 public minAmount = 10000000000000000; // 0.1

    constructor() ERC20("IMAI Token", "IMAI") Ownable(msg.sender) {
        _mint(address(this), 1000000 * 10 ** 18);
        _mint(msg.sender, 20000000 * 10 ** 18);
    }
    receive() external payable {
        require(msg.value >= minAmount, "Minimum BNB amount is 0.1 BNB");
        uint256 tokenAmount = (msg.value * rateAI) / (1 ether);
        require(
            balanceOf(address(this)) >= tokenAmount,
            "Not enough AI tokens in the contract"
        );
        _transfer(address(this), msg.sender, tokenAmount * 10 ** 18);
        emit BuyIMAI(msg.sender, msg.value);
    }

    function rescueERC20(
        address token,
        address to,
        uint amount
    ) external onlyOwner {
        if (token == address(this)) {
            super._transfer(address(this), to, amount);
        } else {
            IERC20(token).transfer(to, amount);
        }
    }

    function rescueETH(address to, uint amount) external onlyOwner {
        payable(to).transfer(amount);
    }

    function setRate(uint256 newRate) external onlyOwner {
        rateAI = newRate;
    }

    function setMinAmount(uint256 newMinAmount) external onlyOwner {
        minAmount = newMinAmount;
    }
}
