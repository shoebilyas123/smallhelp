// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string image;
        string description;
        string title;
        uint256 goal;
        uint256 deadline;
        uint256 amountCollected;
        uint256[] donations;
        address[] donators;
    }

    mapping(uint256=> Campaign) public campaigns;
    uint256 public numberOfCampaigns = 0;

    function createCampaign(address _owner, string memory _image, string memory _title, string memory _description, uint256 _goal, uint256 _deadline) public returns(uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        require(_deadline < block.timestamp, "Deadline must be in the future");

        campaign.owner = _owner;
        campaign.deadline = _deadline;
        campaign.goal = _goal;
        campaign.image = _image;
        campaign.title = _title;
        campaign.description = _description;
        
        numberOfCampaigns++;

    }

    function getAllCampaigns() view public returns(Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage campaignItem = campaigns[i];
            allCampaigns[i] = campaignItem;
        }

        return allCampaigns;
    }

    function getCampaignDetails(uint256 _id) view public returns(Campaign memory) {
        Campaign storage campaign = campaigns[_id];
        return campaign;
    }

    function fundCampaign(uint256 _id)public payable {
        uint256 amountFunded = msg.value;
        Campaign storage campaign = campaigns[_id];
        campaign.donations.push(amountFunded);
        campaign.donators.push(msg.sender);

        (bool sent,) = payable(campaign.owner).call{value: amountFunded}("");

        if(sent)
        campaign.amountCollected += amountFunded;
    }
    function getDonators(uint256 _id)view public returns(address[] memory, uint256[] memory){
        Campaign storage campaign = campaigns[_id];
        return (campaign.donators, campaign.donations);
    }
}