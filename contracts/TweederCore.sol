pragma solidity >=0.4.25 <0.6.0;

contract TweederCore {
    
    mapping (address => TweederTypes.Tweeds) userTweedMap;
    mapping (bytes32 => TweederTypes.TweedReplies) tweedRepliesMap;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    constructor() public {
    }

    function postTweed(string memory receivedContent) public returns(bool) {
        if(!TweederCoreUtils.isContentValid(receivedContent)) return false;

        TweederTypes.TweedContent memory tweedContent = TweederTypes.TweedContent(receivedContent);
        uint nextTweetID = userTweedMap[msg.sender].tweeds.length;
        TweederTypes.Tweed memory tweed = TweederTypes.Tweed(nextTweetID, 
            keccak256("abc"), msg.sender, block.timestamp, tweedContent, false, false);
        userTweedMap[msg.sender].tweeds.push(tweed);
        return true;
    }
    function editTweed(uint tweedIndex, string memory newContent) public returns(bool) {
        if(!TweederCoreUtils.isContentValid(newContent)) return false;

        TweederTypes.Tweed memory editedTweed = userTweedMap[msg.sender].tweeds[tweedIndex];
        editedTweed.content.text = newContent;
        editedTweed.edited = true;
        userTweedMap[msg.sender].tweeds[tweedIndex] = editedTweed;
        return true;
    }

    function replyToTweed(bytes32 tweedUUID, string memory replyContent) public returns(bool) {
        TweederTypes.TweedReplyContent memory tweedReplyContent = TweederTypes.TweedReplyContent(replyContent);
        TweederTypes.TweedReply memory tweedReply = TweederTypes.TweedReply(msg.sender,block.timestamp, tweedReplyContent, false);
        tweedRepliesMap[tweedUUID].replies.push(tweedReply);
        return true;
    }

    function getTweedReply(bytes32 tweedUUID) public view returns(string memory){
        return tweedRepliesMap[tweedUUID].replies[0].content.text;    
    }

    function getTweedID(address user, uint tweedIndex) public view returns(bytes32){
        if(tweedIndex >= userTweedMap[user].tweeds.length)
            return "No Tweeds from user";
        return userTweedMap[user].tweeds[tweedIndex].uuid;      
    }

    function getTweed(address user, uint tweedIndex) public view returns(string memory){
        if(tweedIndex >= userTweedMap[user].tweeds.length)
            return "No Tweeds from user";
        return userTweedMap[user].tweeds[tweedIndex].content.text;      
    }

}

library TweederTypes {
    struct TweedReplyContent {
        string text;
    }

    struct TweedReply {
        address user;
        uint date;
        TweedReplyContent content;
        bool edited;
    }

    struct TweedReplies {
        TweedReply[] replies;
    }

    struct TweedContent {
        string text;
    }

    struct Tweed {
        uint id;
        bytes32 uuid;
        address user;
        uint date;
        TweedContent content;
        bool retweet;
        bool edited;
    }

    struct Tweeds {
        Tweed[] tweeds;
    }
}

library TweederCoreUtils {
    uint constant TWEED_LIMIT = 180;

    function isContentValid(string memory content) internal pure returns(bool valid) {
        uint contentLength = bytes(content).length;
        if (contentLength > TWEED_LIMIT || contentLength == 0)
            return false;
        return true;
    }

    function uint256ToBytes32(uint n) internal pure returns (bytes32) {
        return bytes32(n);
    }
}