// SPDX-License-Identifier: MIT
/**
 * @dev Function to withdraw funds.
 * @custom:dev-run-script "withdrawFunds"
 */

pragma solidity ^0.8.3;

contract TimeLockedWallet {
    address public creator;
    address payable public beneficiary;
    uint public unlockTimestamp;
    uint private lockDuration;
    uint public walletBalance;

    constructor(uint _lockDuration, address payable _beneficiary) payable {
        creator = msg.sender;
        lockDuration = _lockDuration;
        unlockTimestamp = block.timestamp + _lockDuration;
        beneficiary = _beneficiary;
        walletBalance = msg.value;
    }

    modifier onlyCreator {
        require(msg.sender == creator, "Only the creator is allowed to perform this action!");
        _;
    }

    modifier lockExpired {
        require(block.timestamp >= unlockTimestamp, "The lock duration has not expired yet!");
        _;
    }

    modifier validBeneficiary(address _beneficiary) {
        require(_beneficiary != address(0), "Invalid beneficiary address!");
        _;
    }

    function changeCreator(address newCreator) public onlyCreator {
        creator = newCreator;
    }

    function changeBeneficiary(address payable newBeneficiary) public onlyCreator validBeneficiary(newBeneficiary) {
        beneficiary = newBeneficiary;
    }

    function withdrawFunds() public payable lockExpired {
        beneficiary.transfer(address(this).balance);
    }

    function extendLockDuration() public onlyCreator {
        unlockTimestamp = block.timestamp + lockDuration;
    }
}
