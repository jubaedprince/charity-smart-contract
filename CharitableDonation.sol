//SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract CharitableDonation {

    // Struct to hold charitable donors

    struct Donor {
        string name;
        uint amount;
    }

    // Struct for each charity that can receive donations

    struct Charity {
        address payable charityAddr;
        string name;
        uint donationsAccumulated;
        uint targetAmount;
        // a mapping of an individual donor address to a Donor struct which tracks their donation
        mapping(address=>Donor) donors;
    }

    // The charity
    Charity public charity;

    address public administrator;

    // Constructor

    constructor(address payable charityAddress,  string memory charityName) {
        administrator = msg.sender;
        charity.charityAddr = charityAddress;        
        charity.name = charityName;        
    }

    // set the donation target amount
    function setTargetAmount(uint _targetAmount) public {
        require(msg.sender == administrator, "Only the administrator can set the donation target amount!");
        charity.targetAmount = _targetAmount;
   }

   function makeDonation(string memory name) public payable{
       Donor memory donor = Donor(name, msg.value);
       charity.donationsAccumulated += msg.value;
       charity.donors[msg.sender] = donor;
   }

   function releaseFund() public payable{
       if(address(this).balance >= charity.targetAmount){
           charity.charityAddr.transfer(address(this).balance);
       }
   }

    receive() external payable {

    }
}
