import React, { Component } from 'react';
import {Tweeder} from '../../config/web3.config'
import './TweedBox.css';
import TweedPostBox from './TweedPostBox';

export default class TweedBox extends React.Component{
    constructor(props) {
        super(props);
        this.state={
            deleted: false,
            editMode: false,
        };
        this.deleteTweed = this.deleteTweed.bind(this);
    }

    async deleteTweed(tweedID) {
        const succ = await Tweeder.methods.deleteTweed(tweedID).send({gas:500000});
        return succ;
    }

    editMode() {
        this.setState({editMode: !this.state.editMode})
    }

    render() {
        console.log(this.props.tweed);
        return(
        <div className='container'>
            <p>User: {this.props.tweed.user}</p>
            <p> {this.props.tweed.text}</p>
            {(this.props.tweed.user !== 0) && <button onClick={() => this.editMode()}> Edit Tweed</button>}
            {this.state.editMode && <TweedPostBox tweedID={this.props.tweed.id} placeholder={this.props.tweed.text}/>}
            {(this.props.tweed.user !== 0) && <button onClick={() => this.deleteTweed(this.props.tweed.id)}>delete</button>}
        </div>
        );
    }
}

