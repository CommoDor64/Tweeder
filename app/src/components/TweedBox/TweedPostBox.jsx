import React, { Component } from 'react';
import {Tweeder} from '../../config/web3.config'
import './TweedPostBox.css';

export default class TweedPostBox extends Component {
    constructor(props) {
        super(props);
        this.state ={
            text:this.props.placeholder,
        };
        this.onChange = this.onChange.bind(this);
        this.editTweed = this.editTweed.bind(this);
    }

    onChange(e) {
        this.setState({text:e.target.value}, console.log(this.state.text));
    }

    editTweed(tweedID) {
        Tweeder.methods.editTweed(tweedID,this.state.text).send({gas:500000});
    }

    render() {
        return(
            <div>
                <textarea onChange={(e) => this.onChange(e)} placeholder={this.state.text}></textarea>
                <button onClick={() => this.editTweed(this.props.tweedID)}>save!</button>
            </div>
        );
    }

}