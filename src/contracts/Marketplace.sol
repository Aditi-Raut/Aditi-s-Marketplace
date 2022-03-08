pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    uint public productCount = 0;
    mapping(uint => Product) public products;

    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
        );

    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
        );

    constructor() public {
        name = "Aditi's Marketplace";
    }

    function createProduct(string memory _name, uint _price) public
    {
        //Require a Name
        require(bytes(_name).length > 0);

        //Require a valid price
        require(_price > 0);

        //Increment Product Count
        productCount++;

        //Create Product
        products[productCount] = Product(productCount,_name,_price, msg.sender, false);

        // Trigger an Event
        emit ProductCreated(productCount,_name,_price, msg.sender, false);
    }

    function purchaseProduct(uint _id) public payable{
        //Fetch the Product
        Product memory _product = products[_id];

        //Fetch the Owner
        address payable _seller = _product.owner;

        //Make sure the product has a valid id
        require(_product.id > 0 && _product.id <= productCount);
        //Require there is enough ether in the transaction
        require(msg.value >= _product.price);
        //Require that the product has not been purchased Already
        require(!_product.purchased);
        //Require that the buyer is not the seller
        require(_seller != msg.sender);

        //Transfer Ownership to the buyer
        _product.owner = msg.sender;

        //Mark as purchased
        _product.purchased = true;

        //Update the Product
        products[_id] = _product;

        //Pay the seller by sending them ether
        address(_seller).transfer(msg.value);

        //Trigger an event
        emit ProductPurchased(productCount,_product.name,_product.price, msg.sender, true);
    }
}
