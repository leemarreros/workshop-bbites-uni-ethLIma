// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * SwapEtherAndTokens
 *
 * Vamos a crear un contrato que nos permita hacer un swap de ether a tokens.
 * Dicho contrato se llamará SwapEtherAndTokens. Este contrato puede ser
 * usado para comprar los tokens de un proyecto.
 * En principio, cuando token es creado, este token debe ser distribuido.
 * Una manera de hacerlo es através de un contrato donde se pueda comprar el token
 * con otra moneda más conocida, como Ether.
 *
 * Objetivos del contrato SwapEtherAndTokens:
 * 1 - Cuando un usuario llame swapEtherAndTokens, el contrato debe recibir
 *     Ether y enviar tokens al usuario.
 * 2 - Cuando su método receive() sea disparado, el contrato debe recibir Ether
 *     y enviar tokens al usuario.
 * 3 - Tiene un mecanismo para retirar el Ether del contrato usando 'withdrawEther'
 *
 * Nota: el ratio está predefinido en 2500 tokens por 1 Ether para este ejercicio
 *
 *
 * ExecuteOperation
 *
 * El usuario que hará uso del contrato SwapEtherAndTokens será otro contrato
 * llamado ExecuteOperation. Este contrato tiene dos métodos:
 *
 * 1 - function executeWithCall() public:
 *      * Se envia Ether al contrato SwapEtherAndTokens
 *      * Se llama al método swapEtherAndTokens del contrato SwapEtherAndTokens
 * 2 - function executeReceive() public
 *      * Se envia Ether al contrato SwapEtherAndTokens
 *      * Se dispara el método receive() del contrato SwapEtherAndTokens
 */

interface IToken {
    function mint(address to, uint256 amount) external;
}

contract TokenEjercicio7 is ERC20 {
    constructor() ERC20("TokenEjercicio7", "TKN") {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract SwapEtherAndTokens {
    // 1 Eth = 2500 tokens
    uint256 ratio = 2500;

    IToken public token;

    constructor(address tokenAddress) {
        token = IToken(tokenAddress);
    }

    function swapEtherAndTokens() public payable {
        uint256 tokensToMint = msg.value * ratio;
        token.mint(msg.sender, tokensToMint);
    }

    receive() external payable {
        swapEtherAndTokens();
    }

    function withdrawEther(address payable _to) public {
        _to.transfer(address(this).balance);
    }
}

contract ExecuteOperation {
    address swapAddress;

    constructor(address _swapAddress) payable {
        swapAddress = _swapAddress;
    }

    function executeWithCall() public {
        (bool success, ) = payable(swapAddress).call{
            value: address(this).balance,
            gas: 500000
        }(abi.encodeWithSignature("swapEtherAndTokens()"));
        require(success);
    }

    function executeReceive() public {
        (bool success, ) = payable(swapAddress).call{
            value: address(this).balance,
            gas: 500000
        }("");
        require(success);
    }
}
