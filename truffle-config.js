require('babel-register');
require('babel-polyfill');
const HDWalletProvider = require('@truffle/hdwallet-provider');
const privateKeyTest = '566f8b2eb9f7fd0c74833763654097681cc328cc750744e4ea622fe7cbdc0a2d';

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    testnet: {
      provider: () => {
        // use private key
        return new HDWalletProvider({
          //mnemonic,
          providerOrUrl: 'https://api.s0.b.hmny.io', // https://api.s0.t.hmny.io for mainnet
          privateKeys: [privateKeyTest],

          //derivationPath: `m/44'/1023'/0'/0/`
        });
      },
      network_id: 1666700000, // 1666600000 for mainnet
      gas: 20000000,   // <--- Twice as much
      gasPrice: 10000000000,
    },
  },
  contracts_directory: './src/contracts/',
  contracts_build_directory: './src/abis/',
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
}
