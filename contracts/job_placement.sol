// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract JobPlacement {
    struct Job {
        string title;
        string description;
        bool isFilled;
    }

    struct Graduate {
        string name;
        string qualification;
        bool isPlaced;
    }

    Job[] public jobs;
    mapping(address => Graduate) public graduates;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    // Add new job positions
    function addJob(string memory _title, string memory _description) public onlyOwner {
        jobs.push(Job(_title, _description, false));
    }

    // Graduate registers themselves with their qualifications
    function registerGraduate(string memory _name, string memory _qualification) public {
        graduates[msg.sender] = Graduate(_name, _qualification, false);
    }

    // Match graduate with a job based on availability
    function applyForJob(uint _jobId) public {
        require(!graduates[msg.sender].isPlaced, "You are already placed in a job.");
        require(_jobId < jobs.length, "Invalid job ID.");
        require(!jobs[_jobId].isFilled, "This job has already been filled.");

        jobs[_jobId].isFilled = true;
        graduates[msg.sender].isPlaced = true;
    }

    // Retrieve job details
    function getJobDetails(uint _jobId) public view returns (string memory title, string memory description, bool isFilled) {
        require(_jobId < jobs.length, "Invalid job ID.");
        Job memory job = jobs[_jobId];
        return (job.title, job.description, job.isFilled);
    }

    // Check graduate's placement status
    function isGraduatePlaced(address _graduate) public view returns (bool) {
        return graduates[_graduate].isPlaced;
    }
}

