pragma solidity ^0.5.16;

import "./FaucetToken.sol";

/**
 * @title Fee Token
 * @author Compound
 * @notice A simple test token that charges fees on transfer. Used to mock USDT.
 */
contract FeeToken is FaucetToken {
    uint256 public basisPointFee;
    address public owner;

    constructor(
        uint256 _initialAmount,
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol,
        uint256 _basisPointFee,
        address _owner
    ) public FaucetToken(_initialAmount, _tokenName, _decimalUnits, _tokenSymbol) {
        basisPointFee = _basisPointFee;
        owner = _owner;
    }

    function transfer(address dst, uint256 amount) public returns (bool) {
        uint256 fee = amount.mul(basisPointFee).div(10000);
        uint256 net = amount.sub(fee);
        balanceOf[owner] = balanceOf[owner].add(fee);
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
        balanceOf[dst] = balanceOf[dst].add(net);
        emit Transfer(msg.sender, dst, amount);
        return true;
    }

    function transferFrom(
        address src,
        address dst,
        uint256 amount
    ) public returns (bool) {
        uint256 fee = amount.mul(basisPointFee).div(10000);
        uint256 net = amount.sub(fee);
        balanceOf[owner] = balanceOf[owner].add(fee);
        balanceOf[src] = balanceOf[src].sub(amount);
        balanceOf[dst] = balanceOf[dst].add(net);
        allowance[src][msg.sender] = allowance[src][msg.sender].sub(amount);
        emit Transfer(src, dst, amount);
        return true;
    }
}
