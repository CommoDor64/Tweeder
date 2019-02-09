import Web3 from 'web3';
import Tweeder_artifacts from '../contracts/Tweeder.json';
const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
const abi = Tweeder_artifacts.abi;
const address = Tweeder_artifacts.networks[5777].address;
const Tweeder = new web3.eth.Contract(abi, address);
web3.eth.defaultAccount = '0x8Ba74c44ADC4257C8Cb4c22722892673397F9B98';
export { Tweeder, web3 };
