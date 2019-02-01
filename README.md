# Tweeder
## Instructions
    1. clone repo
    2. activate Ganache
    3. truffle compile && truffle migrate && truffle console
    4. in truffle development console: 
        $ let accounts = await web3.eth.getAccounts()
        $ let tweeder = await Tweeder.deployed()
        $ tweeder.getTweed(account[0],0) 
            we expect to get: "No Tweeds from user"
        $ tweeder.postTweed("Hello World!")
        $ tweeder.getTweed(account[0],0) 
            we expect to get: "Hello World!"