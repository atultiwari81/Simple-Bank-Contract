// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract SimpleBank {
    mapping(address => uint256) private balances;
    address public owner;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event BankClosed(address indexed by);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable {
        require(msg.value > 0, "Deposit must be more than zero");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdrawn(msg.sender, _amount);
    }

    function checkBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function closeBank() external onlyOwner {
        emit BankClosed(msg.sender);
        selfdestruct(payable(owner));
    }
}
