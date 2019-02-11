pragma solidity >=0.4.25 <0.6.0;

import "./TweederCore.sol";
import "./TweederCoin.sol";

contract Tweeder is TweederCoin, TweederCore{
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    constructor() public {

    }

}
