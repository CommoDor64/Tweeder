const Tweeder = artifacts.require("Tweeder");

contract('Tweeder', (accounts) => {
  it('should post a tweed', async () => {
    const tweeder = await Tweeder.deployed();
    const accounts = await web3.eth.getAccounts();
    const postedTweed = await tweeder.postTweed("Hello World!");
    const receivedTweed = await tweeder.getTweed(accounts[0], 0);
    assert.equal(receivedTweed.text, "Hello World!", "Didn't post Tweed!");
  });
});