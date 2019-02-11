module.exports = {
  // Uncommenting the defaults below 
  // provides for an easier quick-start with Ganache.
  // You can also follow this format for other networks;
  // see <http://truffleframework.com/docs/advanced/configuration>
  // for more details on how to specify configuration options!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
      gas: 4712388,
      from:"0xBBcFBDCAA798a68156190228D4E7311Bb00733e1"
    },
    test: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
      from:"0xb7fa4d16620ed79c39523730bc54e69727f417bb"
      // gas: 4712388,
    },
    ropsten: {
      host: "127.0.0.1",
      port: 8545,
      network_id: 3,
      gas: 4700000
    },
  }
};
