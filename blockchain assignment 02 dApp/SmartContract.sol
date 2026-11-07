// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title  CourseFeedbackBoard
 * @notice MG3012 - Blockchain Technology for Business | Assignment 2
 *         A tiny on-chain feedback board: anyone can post a short message with a
 *         1-5 star rating, read entries back, upvote entries, and see the average rating.
 *
 * Functions (5):
 *   WRITE  1. postFeedback(message, rating)   - store a new feedback entry
 *   WRITE  2. upvote(id)                      - upvote an entry (once per address)
 *   READ   3. getFeedback(id)                 - read one entry
 *   READ   4. getFeedbackCount()              - number of entries stored
 *   READ   5. getAverageRating()              - average rating x100 (e.g. 425 = 4.25)
 */
contract CourseFeedbackBoard {
    struct Feedback {
        address author;
        string message;
        uint8 rating;      // 1..5
        uint32 upvotes;
        uint64 timestamp;
    }

    uint256 private constant MAX_MESSAGE_LENGTH = 280;

    Feedback[] private feedbacks;
    uint256 private totalRating;
    mapping(uint256 => mapping(address => bool)) private hasUpvoted;

    event FeedbackPosted(uint256 indexed id, address indexed author, uint8 rating, string message);
    event Upvoted(uint256 indexed id, address indexed voter, uint32 newUpvoteCount);

    /// @notice Post a new feedback entry.
    /// @param message Non-empty text, at most 280 bytes.
    /// @param rating  Integer from 1 to 5.
    /// @return id     Index of the newly stored entry.
    function postFeedback(string calldata message, uint8 rating) external returns (uint256 id) {
        uint256 len = bytes(message).length;
        require(len > 0, "Message cannot be empty");
        require(len <= MAX_MESSAGE_LENGTH, "Message too long (max 280)");
        require(rating >= 1 && rating <= 5, "Rating must be 1 to 5");

        id = feedbacks.length;
        feedbacks.push(
            Feedback({
                author: msg.sender,
                message: message,
                rating: rating,
                upvotes: 0,
                timestamp: uint64(block.timestamp)
            })
        );
        totalRating += rating;

        emit FeedbackPosted(id, msg.sender, rating, message);
    }

    /// @notice Upvote an existing entry. Each address may upvote an entry once,
    ///         and cannot upvote its own entry.
    function upvote(uint256 id) external {
        require(id < feedbacks.length, "Feedback does not exist");
        Feedback storage f = feedbacks[id];
        require(f.author != msg.sender, "Cannot upvote your own feedback");
        require(!hasUpvoted[id][msg.sender], "Already upvoted");

        hasUpvoted[id][msg.sender] = true;
        f.upvotes += 1;

        emit Upvoted(id, msg.sender, f.upvotes);
    }

    /// @notice Read one feedback entry.
    function getFeedback(uint256 id)
        external
        view
        returns (address author, string memory message, uint8 rating, uint32 upvotes, uint64 timestamp)
    {
        require(id < feedbacks.length, "Feedback does not exist");
        Feedback storage f = feedbacks[id];
        return (f.author, f.message, f.rating, f.upvotes, f.timestamp);
    }

    /// @notice Total number of feedback entries.
    function getFeedbackCount() external view returns (uint256) {
        return feedbacks.length;
    }

    /// @notice Average rating multiplied by 100 (Solidity has no decimals). 0 if no entries.
    function getAverageRating() external view returns (uint256) {
        if (feedbacks.length == 0) return 0;
        return (totalRating * 100) / feedbacks.length;
    }
}
