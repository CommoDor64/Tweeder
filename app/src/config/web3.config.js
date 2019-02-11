import Web3 from 'web3';
import Tweeder_artifacts from '../contracts/Tweeder.json';
const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
const abi = Tweeder_artifacts.abi;
const address = Tweeder_artifacts.networks[1234].address;
const Tweeder = new web3.eth.Contract(abi, address);
web3.eth.defaultAccount = '0x66fbe4d04fd97925259433bc6bc11985fb536edf';
export { Tweeder, web3 };
