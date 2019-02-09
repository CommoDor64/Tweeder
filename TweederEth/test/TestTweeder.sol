pragma solidity >=0.4.25 <0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Tweeder.sol";

contract TestTweeder {
    function testInitialBalanceUsingDeployedContract() public {
        Tweeder tweeder = Tweeder(DeployedAddresses.Tweeder());

        uint expected = 10000;

        Assert.equal(tweeder.getBalance(msg.sender), expected, "Owner should have 10000 MetaCoin initially");
    }

    // function testInitialBalanceWithNewTweeder() public {
    //     Tweeder tweeder = new Tweeder();

    //     uint expected = 10000;

    //     Assert.equal(tweeder.getBalance(msg.sender), expected, "Owner should have 10000 MetaCoin initially");
    // }

}
