pragma solidity ^0.4.18;


contract Lotto {
    uint256 public ticketPrice = 1 ether;
    address[] private tickets;

    uint256 private durationBlocks = 5;
    uint256 public endBlock;

    function () public payable {
        buyTicket(msg.sender);
    }

    function getNumSoldTickets() public view returns (uint256) {
        return tickets.length;
    }

    function getPrizeAmount() public view returns (uint256) {
        return address(this).balance;
    }

    function startRound() public {
        require(endBlock == 0);
        endBlock = block.number + durationBlocks;
    }

    function buyTicket(address _beneficiary) public payable {
        require(_beneficiary != address(0));
        require(msg.value == ticketPrice);
        require(block.number < endBlock);

        tickets.push(_beneficiary);
    }

    function endRound() public payable {
        require(endBlock > 0 && block.number == endBlock);

        // reset for next round
        endBlock = 0;

        // only pick winner at least one ticket has been sold
        if (tickets.length > 0) {
            uint256 winnerIndex = unsafeRandom() % tickets.length;
            address winner = tickets[winnerIndex];
            tickets = new address[](0);
            winner.transfer(address(this).balance);
        }
    }

    function unsafeRandom() private view returns (uint256) {
        return uint256(block.blockhash(block.number - 1));
    }
}
