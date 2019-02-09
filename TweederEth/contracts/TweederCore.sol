pragma solidity >=0.4.25 <0.6.0;
// pragma experimental ABIEncoderV2;
contract TweederCore {
    // address => tweeds 
    mapping (address => TweederTypes.Tweeds) userTweedMap;
    // uuid => replies
    mapping (bytes32 => TweederTypes.TweedReplies) tweedRepliesMap;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    constructor() public {
    }

    function postTweed(string memory receivedContent) public returns(bool) {
        if(!TweederCoreUtils.isContentValid(receivedContent)) return false;

        TweederTypes.TweedContent memory tweedContent = TweederTypes.TweedContent(receivedContent);
        uint tweedID = userTweedMap[msg.sender].tweeds.length;
        bytes32 tweedUUID = keccak256(abi.encodePacked(tweedID, receivedContent));

        TweederTypes.Tweed memory tweed = TweederTypes.Tweed(tweedID, 
            tweedUUID, msg.sender, block.timestamp, tweedContent, false, false, false);
        userTweedMap[msg.sender].tweeds.push(tweed);
        return true;
    }

    function getTweed(address userAddress, uint tweedIndex) public view returns(
        uint id, bytes32 uuid, address user, uint date, string memory text, bool retweet, bool edited, bool hidden){
        TweederTypes.Tweed memory tweed = userTweedMap[userAddress].tweeds[tweedIndex];
        if(tweedIndex >= userTweedMap[userAddress].tweeds.length || tweed.hidden == true)
            return (uint(0), bytes32(0), address(0), uint(0), string("No Tweeds on this Account!"), false, false, false);
        return (
        tweed.id, tweed.uuid, tweed.user, tweed.date, tweed.content.text, tweed.retweet, tweed.edited, tweed.hidden
        ); 
    }

    function editTweed(uint tweedIndex, string memory newContent) public returns(bool) {
        if(!TweederCoreUtils.isContentValid(newContent)) return false;

        TweederTypes.Tweed memory editedTweed = userTweedMap[msg.sender].tweeds[tweedIndex];
        editedTweed.content.text = newContent;
        editedTweed.edited = true;
        userTweedMap[msg.sender].tweeds[tweedIndex] = editedTweed;
        return true;
    }

    function deleteTweed(uint tweedIndex) public returns(bool) {
        if(tweedIndex > userTweedMap[msg.sender].tweeds.length) return false;
                
        userTweedMap[msg.sender].tweeds[tweedIndex].hidden = true;
        return true;
    }

    function postReply(bytes32 tweedUUID, string memory replyContent) public returns(bool) {
        if(!TweederCoreUtils.isContentValid(replyContent)) return false;

        TweederTypes.TweedReplyContent memory tweedReplyContent = TweederTypes.TweedReplyContent(replyContent);
        bytes32 replyUUID = keccak256(abi.encodePacked(tweedUUID, replyContent));
        uint replyID = tweedRepliesMap[tweedUUID].replies.length;

        TweederTypes.TweedReply memory tweedReply = TweederTypes.TweedReply(replyID,
            replyUUID, msg.sender, block.timestamp, tweedReplyContent, false, false);
        tweedRepliesMap[tweedUUID].replies.push(tweedReply);
        return true;
    }

    function getReply(bytes32 tweedUUID, uint replyIndex) public view returns(
        uint id, bytes32 uuid, address userAdress, uint date, string memory text, bool edited, bool hidden){
        TweederTypes.TweedReply memory tweedReply = tweedRepliesMap[tweedUUID].replies[replyIndex];
        if(replyIndex >= tweedRepliesMap[tweedUUID].replies.length || tweedReply.hidden) 
            return (uint(0), bytes32(0), address(0), uint(0), string("No Replies to this Tweed!"), false, false);
        return (
        tweedReply.id, tweedReply.uuid, tweedReply.user, tweedReply.date, tweedReply.content.text, tweedReply.edited, tweedReply.hidden
        );    
    }

    function editRelpy(bytes32 tweedUUID, uint replyIndex, string memory newContent) public returns(bool) {
        if(!TweederCoreUtils.isContentValid(newContent)) return false;

        TweederTypes.TweedReply memory reply = tweedRepliesMap[tweedUUID].replies[replyIndex];
        reply.content.text = newContent;
        reply.edited = true;
        tweedRepliesMap[tweedUUID].replies[replyIndex] = reply;
        return true;
    }

    function deleteReply(bytes32 tweedUUID, uint replyIndex) public returns(bool) {
        tweedRepliesMap[tweedUUID].replies;
        if(replyIndex > tweedRepliesMap[tweedUUID].replies.length) return false;

        tweedRepliesMap[tweedUUID].replies[replyIndex].hidden = true;
        return true;
    } 

    function getTweedsCount(address user) public view returns(uint) {
        return userTweedMap[user].tweeds.length;
    }

    function getRepliesCount(bytes32 tweedUUID) public view returns(uint) {
        return tweedRepliesMap[tweedUUID].replies.length;
    }

}

library TweederTypes {

    struct TweedReplyContent {
        string text;
    }

    struct TweedReply {
        uint id;
        bytes32 uuid;
        address user; // owner
        uint date;
        TweedReplyContent content;
        bool edited;
        bool hidden;
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
        address user; // owner
        uint date;
        TweedContent content;
        bool retweet;
        bool edited;
        bool hidden;
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

    function pushElement(string[] memory arr, string memory element) internal pure returns(string[] memory){
        arr[arr.length] = element;
        return arr;
    }

    function deleteElement(string[] memory arr, uint toRemoveIndex) internal pure returns(string[] memory){
        string[] memory newArr = new string[](arr.length-1);
        for(uint i = 0; i < arr.length; i++) {
            if(i == toRemoveIndex)
                continue;
            newArr = pushElement(newArr, arr[i]);
        }
        return newArr;        
    }

}