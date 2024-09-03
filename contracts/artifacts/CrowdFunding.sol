// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract CrowdFunding {
    address public immutable beneficiary;   // 受益人
    uint256 public immutable fundingGoal;   // 筹资目标数量
    uint256 public fundingAmount;       // 当前的 金额
    mapping(address=>uint256) public funders;
    mapping(address=>bool) private fundersInserted; // for fundersKey add/update
    address[] public fundersKey; 

    bool public AVAILABLED = true; 
    // 部署的时候，写入受益人+筹资目标数量
    constructor(address beneficiary_,uint256 goal_){
        beneficiary = beneficiary_;
        fundingGoal = goal_;
    }

    function contribute() external payable {
        require(AVAILABLED, "CrowdFunding is closed");

        // 检查捐赠金额是否会超过目标金额
        uint256 potentialFundingAmount = fundingAmount + msg.value;
        uint256 refundAmount = 0;

        if (potentialFundingAmount > fundingGoal) {
            refundAmount = potentialFundingAmount - fundingGoal;
            funders[msg.sender] += (msg.value - refundAmount);
            fundingAmount += (msg.value - refundAmount);
        } else {
            funders[msg.sender] += msg.value;
            fundingAmount += msg.value;
        }

        // 更新捐赠者信息
        if (!fundersInserted[msg.sender]) {
            fundersInserted[msg.sender] = true;
            fundersKey.push(msg.sender);
        }

        // 退还多余的金额
        if (refundAmount > 0) {
            payable(msg.sender).transfer(refundAmount);
        }
    }

    function close() external returns(bool){

        if(fundingAmount<fundingGoal){
            return false;
        }
        uint256 amount = fundingAmount;

        fundingAmount = 0;
        AVAILABLED = false;

        payable(beneficiary).transfer(amount);
        return true;
    }
    function fundersLenght() public view returns(uint256){
        return fundersKey.length;
    }
}