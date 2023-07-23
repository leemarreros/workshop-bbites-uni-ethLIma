// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract LeeMarreros {
    string private fullName;
    address public owner;

    constructor(string memory lastName) {
        owner = msg.sender;
        string memory firstName = "Lee";
        fullName = string.concat(firstName, lastName);
    }

    function getName() public view returns (string memory) {
        return fullName;
    }
}
