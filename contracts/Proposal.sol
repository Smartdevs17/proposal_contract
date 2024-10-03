// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Proposal {
    struct ProposalStruct {
        uint id;
        string description;
        uint voteCount;
        bool executed;
    }

    address public owner;
    uint public proposalCount;
    mapping(uint => ProposalStruct) public proposals;
    mapping(address => mapping(uint => bool)) public votes;

    event ProposalCreated(uint id, string description);
    event Voted(uint proposalId, address voter);
    event ProposalExecuted(uint id);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createProposal(string memory _description) public onlyOwner {
        proposalCount++;
        proposals[proposalCount] = ProposalStruct(proposalCount, _description, 0, false);
        emit ProposalCreated(proposalCount, _description);
    }

    function vote(uint _proposalId) public {
        require(_proposalId > 0 && _proposalId <= proposalCount, "Invalid proposal id");
        require(!votes[msg.sender][_proposalId], "You have already voted for this proposal");

        proposals[_proposalId].voteCount++;
        votes[msg.sender][_proposalId] = true;
        emit Voted(_proposalId, msg.sender);
    }

    function executeProposal(uint _proposalId) public onlyOwner {
        require(_proposalId > 0 && _proposalId <= proposalCount, "Invalid proposal id");
        ProposalStruct storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");

        proposal.executed = true;
        emit ProposalExecuted(_proposalId);
    }

    function getProposal(uint _proposalId) public view returns (uint, string memory, uint, bool) {
        require(_proposalId > 0 && _proposalId <= proposalCount, "Invalid proposal id");
        ProposalStruct memory proposal = proposals[_proposalId];
        return (proposal.id, proposal.description, proposal.voteCount, proposal.executed);
    }
}
