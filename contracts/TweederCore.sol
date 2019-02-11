pragma solidity >=0.4.25 <0.6.0;
contract TweederCore {
    /* 
        mapping between user address and tweeds structs
     */
    mapping (address => TweederTypes.Tweeds) userTweedMap;
    mapping (bytes32 => TweederTypes.TweedReplies) tweedRepliesMap;
    /*
        unused event 
    */
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    constructor() public {
    }

    /*
    * Function:  postTweed 
    * --------------------
    * Creates a new post from the user who issue the transaction
    *
    *  string memory receivedContent: The content of the tweed
    *
    *  returns: success status as boolean
    */
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

    /*
    * Function:  getTweed 
    * -------------------
    * Reads a post from storage
    *
    *  address userAddress: address of the owner of the tweed
    *  uint tweedIndex: index of the tweed on the owner storage
    *  
    *  returns: struct representing the tweed data and metadata 
    */
    function getTweed(address userAddress, uint tweedIndex) public view returns(
        uint id, bytes32 uuid, address user, uint date, string memory text, bool retweet, bool edited, bool hidden){
        TweederTypes.Tweed memory tweed = userTweedMap[userAddress].tweeds[tweedIndex];
        if(tweedIndex >= userTweedMap[userAddress].tweeds.length || tweed.hidden == true)
            return (uint(0), bytes32(0), address(0), uint(0), string("No Tweeds on this Account!"), false, false, true);
        return (
        tweed.id, tweed.uuid, tweed.user, tweed.date, tweed.content.text, tweed.retweet, tweed.edited, tweed.hidden
        ); 
    }

    /*
    * Function:  editTweed 
    * --------------------
    * Updates a post from storage
    *
    *  uint tweedIndex: index of the tweed on the owner storage
    *  string memory newContent: tweed's new content
    *  
    *  returns: returns: success status as boolean 
    */
    function editTweed(uint tweedIndex, string memory newContent) public returns(bool) {
        if(!TweederCoreUtils.isContentValid(newContent)) return false;

        TweederTypes.Tweed memory editedTweed = userTweedMap[msg.sender].tweeds[tweedIndex];
        editedTweed.content.text = newContent;
        editedTweed.edited = true;
        userTweedMap[msg.sender].tweeds[tweedIndex] = editedTweed;
        return true;
    }

    /*
    * Function:  deleteTweed 
    * ----------------------
    * deletes a post from storage 
    *
    *  uint tweedIndex: index of the tweed on the owner storage
    *  
    *  returns: returns: success status as boolean 
    */
    function deleteTweed(uint tweedIndex) public returns(bool) {
        if(tweedIndex > userTweedMap[msg.sender].tweeds.length) return false;
                
        userTweedMap[msg.sender].tweeds[tweedIndex].hidden = true;
        return true;
    }

    /*
    * Function:  postReply 
    * --------------------
    * Creates a new post from the user who issue the transaction
    *  bytes32 tweedUUID: uuid represents a tweed
    *  string memory receivedContent: The content of the reply
    *
    *  returns: success status as boolean
    */
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

    /*
    * Function:  getReply 
    * -------------------
    * Reads a reply from storage
    *
    *  bytes32 tweedUUID: uuid represents a tweed
    *  uint replyIndex: index of the reply on the tweeds storage
    *  
    *  returns: struct representing the tweed data and metadata 
    */
    function getReply(bytes32 tweedUUID, uint replyIndex) public view returns(
        uint id, bytes32 uuid, address userAdress, uint date, string memory text, bool edited, bool hidden){
        TweederTypes.TweedReply memory tweedReply = tweedRepliesMap[tweedUUID].replies[replyIndex];
        if(replyIndex >= tweedRepliesMap[tweedUUID].replies.length || tweedReply.hidden) 
            return (uint(0), bytes32(0), address(0), uint(0), string("No Replies to this Tweed!"), false, true);
        return (
        tweedReply.id, tweedReply.uuid, tweedReply.user, tweedReply.date, tweedReply.content.text, tweedReply.edited, tweedReply.hidden
        );    
    }

    /*
    * Function:  editReply
    * --------------------
    * Updates a reply on storage
    *
    *  bytes32 tweedUUID: uuid represents a tweed
    *  string memory newContent: reply's new content
    *  
    *  returns: returns: success status as boolean 
    */
    function editReply(bytes32 tweedUUID, uint replyIndex, string memory newContent) public returns(bool) {
        address owner = tweedRepliesMap[tweedUUID].replies[replyIndex].user;
        if(!TweederCoreUtils.isContentValid(newContent)) return false;
        if(msg.sender != owner) return false;

        TweederTypes.TweedReply memory reply = tweedRepliesMap[tweedUUID].replies[replyIndex];
        reply.content.text = newContent;
        reply.edited = true;
        tweedRepliesMap[tweedUUID].replies[replyIndex] = reply;
        return true;
    }

    /*
    * Function:  deleteTweed 
    * ----------------------
    * deletes a comment from storage 
    *
    *  bytes32 tweedUUID: uuid represents a tweed
    *  uint reply: index of the tweed on the owner storage
    *  
    *  returns: returns: success status as boolean 
    */
    function deleteReply(bytes32 tweedUUID, uint replyIndex) public returns(bool) {
        address owner = tweedRepliesMap[tweedUUID].replies[replyIndex].user;
        if(replyIndex > tweedRepliesMap[tweedUUID].replies.length) return false;
        if(msg.sender != owner) return false;

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
}