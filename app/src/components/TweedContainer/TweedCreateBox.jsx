import React, { Component } from 'react';
import {Tweeder} from '../../config/web3.config'
import './TweedCreateBox.css';

export default class TweedPostBox extends Component {
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