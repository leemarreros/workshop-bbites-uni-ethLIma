// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// each address has a mapping with array of structs

contract Register16 {
    //enum ColorInfo {Undefined = 0, Blue = 1, Blue = 2}
    enum ColorInfo {
        Undefined,
        Blue,
        Red
    }

    struct InfoStruct {
        ColorInfo color;
        string info;
        uint countChanges;
    }
    mapping(address => InfoStruct[]) public infos;

    constructor() {
        InfoStruct memory infoAux = InfoStruct({
            color: ColorInfo.Undefined,
            info: "Sol",
            countChanges: 0
        });
        infos[msg.sender].push(infoAux);
    }

    event InfoChange(address person, string oldInfo, string newInfo);

    address owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier onlyWhitelist() {
        require(whiteList[msg.sender] == true, "Only whitelist");
        _;
    }
    mapping(address => bool) whiteList;

    function getInfo(
        uint index
    ) public view returns (ColorInfo, string memory) {
        return (infos[msg.sender][index].color, infos[msg.sender][index].info);
    }

    function setInfo(
        uint index,
        ColorInfo _color,
        string memory _info
    ) public onlyWhitelist {
        emit InfoChange(msg.sender, infos[msg.sender][index].info, _info);
        infos[msg.sender][index].color = _color;
        infos[msg.sender][index].info = _info;
    }

    function addInfo(
        ColorInfo _color,
        string memory _info
    ) public onlyWhitelist returns (uint index) {
        InfoStruct memory infoAux = InfoStruct({
            color: _color,
            info: _info,
            countChanges: 0
        });
        infos[msg.sender].push(infoAux);
        index = infos[msg.sender].length - 1;
    }

    function addMember(address _member) public onlyOwner {
        whiteList[_member] = true;
    }

    function delMember(address _member) public onlyOwner {
        whiteList[_member] = false;
    }
}
