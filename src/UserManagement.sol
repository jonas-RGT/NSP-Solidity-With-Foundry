//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.13;

contract UserManagement {
    enum UserStatus {
        Active,
        Suspended,
        Banned
    }

    struct User {
        uint256 registrationDate;
        string name;
        UserStatus status;
        bool exists;
    }

    mapping(address => User) public users;

    event UserRegistered(address indexed userAddress, string name, uint256 timestamp);
    event UserStatusChanged(address indexed userAddress, UserStatus newStatus);

    //Add new user
    function registerUser(string memory _name) external {
        User storage user = users[msg.sender];

        require(!user.exists, "User already registered");
        require(bytes(_name).length != 0, "Name cannot be empty");

        users[msg.sender] =
            User({name: _name, registrationDate: block.timestamp, status: UserStatus.Active, exists: true});

        emit UserRegistered(msg.sender, _name, block.timestamp);
    }

    //Update Status
    function updateUserStatus(UserStatus _newStatus) external {
        User storage user = users[msg.sender];

        require(user.exists, "User doesn't exist");
        user.status = _newStatus;

        emit UserStatusChanged(msg.sender, _newStatus);
    }

    //Retrieve User data
    function getUser(address _userAddress)
        public
        view
        returns (string memory name, uint256 registrationDate, UserStatus status, bool exists)
    {
        User storage user = users[_userAddress];
        return (user.name, user.registrationDate, user.status, user.exists);
    }
}
