//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

struct NameStruct {
    address owner;
    address scName;
    string name;
}

interface iEthKipuSolidity {
    function addName(
        address scNameAddress,
        string memory name
    ) external returns (bool);

    function deleteName() external returns (bool);

    function existsOwner(address account) external view returns (bool);

    function getNameInfoByOwner(
        address account
    ) external view returns (NameStruct memory);

    function owner() external view returns (address);

    function courseInfo() external view returns (string memory);
}
