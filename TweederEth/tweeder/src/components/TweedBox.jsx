import React, { Component } from 'react';
import {Tweeder} from '../config/web3.config'
import './TweedBox.css';

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
        const succ = await Tweeder.methods.deleteTweed(tweedID).send();
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
            <p> Says {this.props.tweed.text}</p>
            {(this.props.tweed.user !== 0) && <button onClick={() => this.editMode()}> Edit Tweed</button>}
            {this.state.editMode && <TweedPostBox tweedID={this.props.tweed.id} placeholder={this.props.tweed.text}/>}
            {(this.props.tweed.user !== 0) && <button onClick={() => this.deleteTweed(this.props.tweed.id)}>delete</button>}
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
        this.editTweed = this.editTweed.bind(this);
    }

    onChange(e) {
        this.setState({text:e.target.value}, console.log(this.state.text));
    }

    editTweed(tweedID) {
        Tweeder.methods.editTweed(tweedID,this.state.text).send();
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