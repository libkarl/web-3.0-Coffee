// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract BuyMeACoffee {
   // Event to emit when a Memo is created.
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );
    
    // Memo struct.
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // Address of contract deployer
    // adresa na kterou chodí prostředky
    address payable owner; 

    // List of all memos received from coffee purchases.
    Memo[] memos;

    // All code inside the constructor is just logic which
    // runs just one time. (When the contract is created )
    
    constructor() {
        // při uložení kontraktu do blockchainu, říká komu kontrakt patří
        // (kdo je sender)
        // takže když deploynu tenhle kontrakt s mou metamask peněženkou 
        // msg.sender == adresa mojí peněženky
        owner = payable(msg.sender);
    }

    /**
     * @dev buy a coffee for owner (sends an ETH tip and leaves a memo)
     * @param _name name of the coffee purchaser
     * @param _message a nice message from the purchaser
     */

    // We want add money to this constract so we alow this function to be payable 
    // s tím lze funkci zaplatit, navíc přidám public, protože funkce má být viditelná pro všechny (všichni mají možnost mi koupit kafe)
    function buyCoffee(string memory _name, string memory _message) public payable {
        // množštví, které bylo zaplaceno je uloženo v msg.value 
        // check if it is bigger than zero
        require(msg.value > 0, "can't buy coffee with 0 eth");

        // pouze naplnění struktury Memo obdženými informacemi a push do předpřipravého pole
        // add the memo to storage (smartcontract blockchain storage)
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        // emit a log event when a nemom is created
        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );
    }

    /**
     * @dev send the entire balance stored in the contract to the owner
     */

    function withdrawTips() public {
       // address(this).balance -> this is where the money is stored
       // kdokoli zavolá tuhle funkci, způsobí že všechny peníze v kontraktu se pošlou na adresu owner (creator address)
        require(owner.send(address(this).balance));
    }

    /**
     * @dev retrieve all the memos tored on the blockchain
     */
    // když je funkce view, znamená to, že nevyvolává, v blockchainu žádné změny
    // takže nespotřebovává gas
    // nevyvolává změny protože pouze čte aktuální stav a vrací ho do memory 
    function getMemos() public view returns(Memo[] memory) {
        return memos;
    }

}
