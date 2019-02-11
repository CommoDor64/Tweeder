# Tweeder
Tweeter clone offers post, edit and delete of tweeds, built on Rhea blockchain
There are two options for usage, directly with web3.js API or with React app
## Usage
### general for both options
    Since there is no option to connect / deploy directly with ssh, we will have to
    create a local forwarding to the ssh connection
    $ ssh -L 8545:127.0.0.1:8545 user6@160.45.38.66 

    After entering the password (provided on kvv submition), a geth client must be running
    // on rhea machine
    $ ./startGeth.sh

### Usage with react app
    Now you can set up the app
    $ git clone git@github.com:CommoDor64/Tweeder.git Tweeder
    $ cd app && npm install
    $ npm start

    Now, go to: http://localhost:3000, there you'll be able to create, edit and delete tweeds

    NOTE: usually it takes sometime until the blockchain settels, up to a minute for some reason

### Usage with web3.js interaction console (geth attach)
###API:
    Information regarding Contrarct location and ABI are in
    /path/to/project/build/contracts/Tweeder.json
    In this case, the address is 0x7c6Dd7fE0D1CCbDe3BFd784595Bc7CfAE5cfaF2E

    after using the web3.js api to create an instance of the contract as a js object
    the following functions are to be used:

    function postTweed(string memory receivedContent) public returns(bool)

    function getTweed(address userAddress, uint tweedIndex) public view returns(
        uint id, bytes32 uuid, address user, uint date, string memory text, bool retweet, bool edited, bool hidden)

    function editTweed(uint tweedIndex, string memory newContent) public returns(bool)

    function deleteTweed(uint tweedIndex) public returns(bool)

    function postReply(bytes32 tweedUUID, string memory replyContent) public returns(bool)

    function getReply(bytes32 tweedUUID, uint replyIndex) public view returns(
        uint id, bytes32 uuid, address userAdress, uint date, string memory text, bool edited, bool hidden)

    function editReply(bytes32 tweedUUID, uint replyIndex, string memory newContent) public returns(bool)

    function deleteReply(bytes32 tweedUUID, uint replyIndex) public returns(bool)

    function getTweedsCount(address user) public view returns(uint)

    function getRepliesCount(bytes32 tweedUUID) public view returns(uint)

## dependencies
    - node and npm

## misc:
    - completely unsecure approach, users basically can try and delete ot edit others tweeds,
    the limitation is from the frontend not from the solidity code, which is risky.