pragma solidity ^0.5.0;

contract Kahaaniya {

    uint public storyCount;
    mapping(uint => Story) public stories;
    mapping(address => uint[]) public purchasedStories; 

    struct Story {
        uint id;
        string title;
        string storyText;
        uint price;
        address payable owner;
        bool purchased;
    }

    event StoryCreated(
        uint id,
        string title,
        string storyText,
        uint price,
        address payable owner,
        bool purchased
    );

    event StoryPurchased(
        uint id,
        string title,
        string storyText,
        uint price,
        address payable owner,
        bool purchased
    );

    constructor() public {
    }

    function createStory(string memory _title, uint _price, string memory _storyText) public {
        // Require a valid title
        require(bytes(_title).length > 0, "Story should have title");
        // Require a valid price
        require(_price > 0, "Story should have some price");
        //require a valid story
        require(bytes(_storyText).length > 0, "Story should have content");
        // Increment story count
        storyCount ++;
        // Create the story
        stories[storyCount] = Story(storyCount, _title, _storyText, _price, msg.sender, false);
        // Trigger an event
        emit StoryCreated(storyCount, _title, _storyText, _price, msg.sender, false);
    }

    function purchaseStory(uint _id) public payable {
        // Fetch the product
        Story memory _story = stories[_id];
        // Fetch the owner
        address payable _seller = _story.owner;
        // Make sure the product has a valid id
        require(_story.id > 0 && _story.id <= storyCount);
        // Require that there is enough Ether in the transaction
        require(msg.value >= _story.price);
        // Require that the product has not been purchased already
        require(!_story.purchased);
        // Require that the buyer is not the seller
        require(_seller != msg.sender);
        // Transfer ownership to the buyer
        _story.owner = msg.sender;
        // Mark as purchased
        _story.purchased = true;
        // Update the product
        stories[_id] = _story;
        // Updated purchased stories mapping
        purchasedStories[msg.sender].push(_story.id);
        // Pay the seller by sending them Ether
        address(_seller).transfer(msg.value);
        // Trigger an event
        emit StoryPurchased(storyCount, _story.title, _story.storyText, _story.price, msg.sender, true);
    }

    function isStoryPurchasedByUser(uint _id) public returns(bool) {
        //TODO: Need to implement logic on search through array of story ids in purchasedStories mapping
        return false;
    }

    function storiesPurchasedByUser() public returns(uint[] memory){
        if(purchasedStories[msg.sender].length > 0) {
            return purchasedStories[msg.sender];
        }else {
            //TODO: Return empty
        }
    }
}