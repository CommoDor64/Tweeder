# Tweeder
The entire logic is inn Tweeder.sol, You are welcome to peak in, getTweed(...) and postTweed(...) made by me.
The rest of the functions are from the example boilerplate
## Instructions
    1. Clone repo cd into the project's root directory
    2. Activate Ganache
    3. $ truffle compile && truffle migrate && truffle console
    4. in truffle development console: 
        $ let accounts = await web3.eth.getAccounts()
        $ let tweeder = await Tweeder.deployed()
        $ tweeder.getTweed(accounts[0],0) 
            we expect to get: "No Tweeds from user"
        $ tweeder.postTweed("Hello World!")
        $ tweeder.getTweed(accounts[0],0) 
            we expect to get: "Hello World!"
