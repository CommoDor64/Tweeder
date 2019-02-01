pragma solidity >=0.4.25 <0.6.0;

import "./ConvertLib.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract Tweeder {
    mapping (address => uint) balances;
    mapping (address => string[]) tweeds;
    uint TWEED_LIMIT = 180;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    constructor() public {
        balances[msg.sender] = 10000;
    }

    function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
        if (balances[msg.sender] < amount) return false;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }
    function postTweed(string memory tweed) public returns(bool succ) {
        uint tweedLength = bytes(tweed).length;
        if (tweedLength > TWEED_LIMIT || tweedLength == 0)
            return false;
        tweeds[msg.sender].push(tweed);
        return true;
    }
    
    function getTweed(address user, uint tweedIndex) public view returns(string memory usersTweeds){
        if(tweedIndex >= tweeds[user].length)
            return "No Tweeds from user";
        return tweeds[user][tweedIndex];      
    }

    function getBalanceInEth(address addr) public view returns(uint){
        return ConvertLib.convert(getBalance(addr),2);
    }

    function getBalance(address addr) public view returns(uint) {
        return balances[addr];
    }
}