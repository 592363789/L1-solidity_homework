// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Bank {
    address public immutable owner;
    
    event Deposit(address sender, uint amount);
    event Withdraw(uint amount);
    event TokenDeposit(address token, address sender, uint amount);
    event TokenWithdraw(address token, uint amount);
    event NFTDeposit(address token, address sender, uint256 tokenId);
    event NFTWithdraw(address token, uint256 tokenId);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    constructor() payable { 
        owner = msg.sender;
    }

    function withdraw() external onlyOwner {
        emit Withdraw(address(this).balance);
        selfdestruct(payable(owner));
    }

    function depositTokens(address token, uint amount) external {
        IERC20(token).transferFrom(msg.sender, payable(this), amount);
        emit TokenDeposit(token, msg.sender, amount);
    }

    function withdrawTokens(address token) external onlyOwner {
        uint balance = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(owner, balance);
        emit TokenWithdraw(token, balance);
        selfdestruct(payable(owner));
    }

    // 存储 ERC-721 代币
    function depositNFT(address token, uint256 tokenId) external {
        IERC721(token).transferFrom(msg.sender, address(this), tokenId);
        emit NFTDeposit(token, msg.sender, tokenId);
    }

    // 提取 ERC-721 代币
    function withdrawNFT(address token, uint256 tokenId) external onlyOwner {
        IERC721(token).transferFrom(address(this), owner, tokenId);
        emit NFTWithdraw(token, tokenId);
        selfdestruct(payable(owner));
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}