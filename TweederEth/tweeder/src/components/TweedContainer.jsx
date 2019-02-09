import React, { Component } from 'react';
import {Tweeder, web3} from '../config/web3.config'

import './TweedContainer.css';
import TweedBox from './TweedBox'

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
                tweeds.push(await Tweeder.methods.getTweed(account,i).call());
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
                <TweedPostBox placeholder={'Make Ethereum Great Again!'}/>

                {this.state.tweeds.map((tweed) => <TweedBox key={tweed.uuid} tweed={tweed}/>)}
            </div>     
        </div>
        );
    }
}

class TweedPostBox extends Component {
    constructor(props) {
        super(props);
        this.state ={
            text:this.props.placeholder,
        };
        this.onChange = this.onChange.bind(this);
        this.postTweed = this.postTweed.bind(this);
    }

    onChange(e) {
        this.setState({text:e.target.value}, console.log(this.state.text));
    }

    postTweed(text) {
        Tweeder.methods.postTweed(text).send({gas:150000});
    }

    render() {
        return(
            <div>
                <textarea onChange={(e) => this.onChange(e)} placeholder={this.state.text}></textarea>
                <button onClick={() => this.postTweed(this.state.text)}>Tweed!</button>
            </div>
        );
    }

}