import React, { Component } from 'react';
import {Tweeder, web3} from '../../config/web3.config'
import './TweedContainer.css';
import TweedBox from '../TweedBox/TweedBox'
import TweedCreateBox from './TweedCreateBox'

export default class TweedContainer extends Component {
    constructor(props) {
        super(props);
        this.state={
            tweeds:[]
        };
        this.getAllTweeds = this.getAllTweeds.bind(this);
    }

    componentDidMount() {
        this.getAllTweeds();
    }

    async postTweed() {

    }

    async getAllTweeds() {
        const accounts = await web3.eth.getAccounts();
        var tweeds = [];
        for(let account of accounts) {
            let tweedsCount = await Tweeder.methods.getTweedsCount(account).call();
            for(let i = 0; i < tweedsCount; i++) {
                let tweed = await Tweeder.methods.getTweed(account,i).call();
                console.log(tweed);

                if(tweed.hidden){
                    continue;
                }
                else
                    tweeds.push(tweed);
            }
        }
        this.setState({tweeds:this.sortTweedsByTimestamp(tweeds)});     
    }

    sortTweedsByTimestamp(tweeds) {
        return tweeds.sort((a,b) => parseInt(a.date) - parseInt(b.date));
    }

    render() {
        console.log(this.state.tweeds);
        return(
        <div>
            <div className='container'>
                <TweedCreateBox placeholder={'Make Ethereum Great Again!'}/>

                {this.state.tweeds.map((tweed) => <TweedBox key={tweed.uuid} tweed={tweed}/>)}
            </div>     
        </div>
        );
    }
}

