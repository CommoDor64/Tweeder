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

    Now, go to: http://localhost:3000, there you'll be able to create, edit and delete tweeds,
    no frontend support for commenting, this can be done by web3.js API and functions below.

    NOTE: usually it takes sometime until the blockchain settels, up to a minute for some reason

### Usage with web3.js interaction console (geth attach)
###API:
    Information regarding Contrarct location and ABI are in
    /path/to/project/build/contracts/Tweeder.json
    In this case, the address is 0x7c6Dd7fE0D1CCbDe3BFd784595Bc7CfAE5cfaF2E

    after using the web3.js api to create an instance of the contract as a js object
    the following functions are to be used:

    - function postTweed(string memory receivedContent) public returns(bool)
    post tweed with "hello world!"

    example: >> contractInstance.methods.postTweed("hello world!")

    - function getTweed(address userAddress, uint tweedIndex) public view returns(
        uint id, bytes32 uuid, address user, uint date, string memory text, bool retweet, bool edited, bool hidden)
    Let's fetch the first tweed of account 0x1233455

    example: >> contractInstance.methods.getTweed("0x1233455",0) 


    - function editTweed(uint tweedIndex, string memory newContent) public returns(bool)
    example: >> contractInstance.methods.editTweed(0,"Hello World2!") // the user is implied, depends on the default account (msg.sender)
    
    - function deleteTweed(uint tweedIndex) public returns(bool)
    example: >> contractInstance.methods.editTweed(0) // again, user is implied, depends on default account (msg.sender)
    
    - function postReply(bytes32 tweedUUID, string memory replyContent) public returns(bool)
    post a comment, by passing tweedsUUID(is a part of the Tweed struct)

    example: >> contractInstance.methods.postReply("0x3428795043534...", "you suck!") // again, user is implied, depends on default account (msg.sender)

    - function getReply(bytes32 tweedUUID, uint replyIndex) public view returns(
        uint id, bytes32 uuid, address userAdress, uint date, string memory text, bool edited, bool hidden)
        example: >> contractInstance.methods.getReply("0x3428795043534...", 0)

    - function editReply(bytes32 tweedUUID, uint replyIndex, string memory newContent) public returns(bool)
        example: >> contractInstance.methods.editReply("0x3428795043534...", "no, you suck!")

    - function deleteReply(bytes32 tweedUUID, uint replyIndex) public returns(bool)
        example: >> contractInstance.methods.deleteReply("0x3428795043534...",0)

    - function getTweedsCount(address user) public view returns(uint)
        example: >> contractInstance.methods.getTweedsCount("0x348920385...")

    - function getRepliesCount(bytes32 tweedUUID) public view returns(uint)
        example: >> contractInstance.methods.getRepliesCount("0x29420854380..")

## dependencies
    - node and npm

## misc:
    - completely unsecure approach, users basically can try and delete ot edit others tweeds,
    the limitation is from the frontend not from the solidity code, which is risky.