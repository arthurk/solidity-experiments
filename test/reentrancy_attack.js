var Bank = artifacts.require('Bank');
var Attacker = artifacts.require('Attacker');

contract('Bank', (accounts) => {
    var bankInstance;

    it('should put 10 ether in the Bank', () => {
        var account_0_starting_balance;
        var account_0_ending_balance;

        var bank_starting_balance;
        var bank_ending_balance;
        var gasUsed;

        return Bank.deployed().then(instance => {
            bankInstance = instance;
            return web3.eth.getBalance(accounts[0]);
        }).then(balance => {
            account_0_starting_balance = balance.toNumber();
            return web3.eth.getBalance(bankInstance.address);
        }).then(balance => {
            bank_starting_balance = balance.toNumber();
            return bankInstance.deposit({value: web3.toWei(10)})
        }).then((result) => {
            gasUsed = result.receipt.gasUsed;
            return web3.eth.getBalance(accounts[0]);
        }).then(balance => {
            account_0_ending_balance = balance.toNumber();
            return web3.eth.getBalance(bankInstance.address);
        }).then(balance => {
            bank_ending_balance = balance.toNumber();

            assert.equal(bank_starting_balance, 0, 'Bank starting balance is not 0');
            assert.equal(bank_ending_balance, web3.toWei(10), 'Bank has not received 10 ether');
        });
    });

    it('should have 0 ether in the Attacker balance', () => {
        var attackerBalance;

        return Attacker.deployed().then(instance => {
            return web3.eth.getBalance(instance.address);
        }).then(balance => {
            attackerBalance = balance.toNumber();

            assert.equal(attackerBalance, web3.toWei(0), 'attacker balance is not 0');
        });
    });

    it('should transfer 10 ether to the attacker', () => {
        var attackerInstance;

        var bankBalance;
        var attackerBalance;

        return Attacker.deployed().then(instance => {
            attackerInstance = instance;
            return attackerInstance.start();
        }).then(result => {
            return web3.eth.getBalance(bankInstance.address);
        }).then(balance => {
            bankBalance = balance.toNumber();
            return web3.eth.getBalance(attackerInstance.address);
        }).then(balance => {
            attackerBalance = balance.toNumber();

            assert.equal(bankBalance, web3.toWei(0), 'bank balance is not 0');
            assert.equal(attackerBalance, web3.toWei(10), 'attacker balance is not 10');
        });
    });
});
