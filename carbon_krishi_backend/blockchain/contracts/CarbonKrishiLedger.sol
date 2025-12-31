// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CarbonKrishiLedger {

    struct Submission {
        string dataHash;
        address submittedBy;
        uint256 timestamp;
        bool verified;
    }

    uint256 public submissionCount;
    mapping(uint256 => Submission) public submissions;

    event SubmissionAdded(
        uint256 indexed id,
        string dataHash,
        address submittedBy
    );

    event SubmissionVerified(
        uint256 indexed id,
        address verifier
    );

    function addSubmission(string memory _dataHash) public {
        submissionCount++;
        submissions[submissionCount] = Submission(
            _dataHash,
            msg.sender,
            block.timestamp,
            false
        );

        emit SubmissionAdded(submissionCount, _dataHash, msg.sender);
    }

    function verifySubmission(uint256 _id) public {
        require(_id > 0 && _id <= submissionCount, "Invalid submission");
        submissions[_id].verified = true;

        emit SubmissionVerified(_id, msg.sender);
    }
}
