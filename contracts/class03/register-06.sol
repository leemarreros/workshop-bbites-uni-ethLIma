// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// require owner

contract Register06 {
    string private info;
    uint public countChanges = 0;
    address public owner;

    error OnlyOwner();

    constructor() {
        owner = msg.sender;
        info = "Sol";
    }

    function getInfo() public view returns (string memory) {
        return info;
    }

    function setInfo(string memory _info) external {
        // require(msg.sender == owner, "Only owner");
        if (msg.sender != owner) revert OnlyOwner();
        info = _info;
        countChanges++;
    }
}
