pragma solidity ^0.5.0;
 
import "./Owned.sol";

contract MarketPlace is Owned{

	struct InventoryProduct {
		uint productKey;
		string productName;
		string productClass;
		uint quantity;
	}

	struct StoreFront {
		string name;
		mapping(uint => InventoryProduct) inventoryProductMap;	
	}	

	struct OrderItem {
		uint productKey;
		uint quantity;
		uint price;
	}

	struct ShoppingCart {
		mapping(uint => OrderItem) orderItemMap;
	} 


	struct StoreOwner {
		address storeOwnerAddress;
		uint storeOwnerKey;
		string firstName;
		string lastName;
		bool isActive;
	}

	struct Customer {
		address customerAddress;
		uint customerKey;
		string firstName;
		string lastName;
		bool isActive;
	}

	// Collections that can be returned from functions
	address[] customerAddressArr;
	address[] storeOwnerAdressArr;

	mapping (address => Customer) public customers;
	mapping (address => StoreOwner) public storeOwners;
	// Store Owner A --> (count = 2) ,  Store Owner B --> (count = 5)

	// Store Owner A --> (Struct) ,  Store Owner B --> (Struct)
	mapping (address => mapping(uint => StoreFront)) public ownerStoreFrontsMapMap;
	// Store Owner A --> [1,2,3] , Store Owner B --> [1,2,3]
	mapping (address => uint[]) public ownerStoreFrontIDsMapArr;
	// Store Owner A --> (count = 2) ,  Store Owner B --> (count = 5)
	mapping (address => uint) public ownerStoreFrontsCountMap;  
	// Map of Shopping Cart by Customer Addresss
	mapping (address => ShoppingCart) shoppingCarts; 

	modifier onlyCustomer{
		require(customers[msg.sender].isActive,"User Not Authorized. Only Customers can call this function");
		_;
	}

	modifier onlyStoreOwner{
		require(storeOwners[msg.sender].isActive,"User Not Authorized. Only StoreOwners can call this function");
		_;
	}

	// Add Customer
	function registerCustomer(string memory firstName, string memory lastName) public returns (bool) {
		require(bytes(firstName).length > 0 && bytes(lastName).length > 0 ,"First Name or Last Name appears empty");
	    Customer memory custObj = Customer(msg.sender,1,firstName,lastName,true);
		customers[msg.sender] = custObj;
		shoppingCarts[msg.sender] = ShoppingCart();
		return true;
	}

	// Add StoreOwner , Set store front count to be 10 max 
  	function registerStoreOwner(string memory firstName, string memory lastName) public returns (bool){
  		require(bytes(firstName).length > 0 && bytes(lastName).length > 0 ,"First Name or Last Name appears empty");
  		StoreOwner memory storeOwnerObj = StoreOwner(msg.sender,1,firstName,lastName,true);
  		storeOwners[msg.sender] = storeOwnerObj;
  		//ownerStoreFrontsMapMap[msg.sender] = OwnerStoreFrontMap();
  		ownerStoreFrontsCountMap[msg.sender] = 0;
  		ownerStoreFrontIDsMapArr[msg.sender] = new uint[](10);
  		return true;
  	}

  	// Add StoreFront
 	function registerStoreFront(string memory storeName) public onlyStoreOwner returns (bool){
 		require(bytes(storeName).length > 0,"Store Name appears empty");
 		StoreFront memory storeFrontObj = StoreFront(storeName);
  		ownerStoreFrontsMapMap[msg.sender][ownerStoreFrontsCountMap[msg.sender]] = storeFrontObj;
  		ownerStoreFrontIDsMapArr[msg.sender][ownerStoreFrontsCountMap[msg.sender]] = ownerStoreFrontsCountMap[msg.sender];
  		ownerStoreFrontsCountMap[msg.sender] = ownerStoreFrontsCountMap[msg.sender] + 1; 
  		return true;
 	}

 	function unregisterCustomer() public onlyCustomer returns (bool){
 		customers[msg.sender].isActive = false;
 		return true;
 	}

  	function unregisterStoreOwner() public onlyStoreOwner returns (bool){
  		storeOwners[msg.sender].isActive = false;
  		return true;
  	}

  	function unregisterStoreFront(address storeFrontAddress) public onlyStoreOwner returns (bool){
  		return false;
  	}

  	function addToShoppingCart(uint productkey, uint quantity, uint price) public onlyCustomer returns (bool){
  		shoppingCarts[msg.sender].orderItemMap[productkey].quantity = quantity;
  		shoppingCarts[msg.sender].orderItemMap[productkey].price = price;
  		return true;
  	}

	function removeFromShoppingCart(uint productkey, uint quantity) public onlyCustomer returns (bool){
		return false;
	}

	function getAllStoreFrontsByOwner() public onlyStoreOwner onlyAdmin returns (uint[] memory) {
		return ownerStoreFrontIDsMapArr[msg.sender];
	}

	function getShoppingCartItems() public view onlyCustomer onlyStoreOwner onlyAdmin returns (bool){
		return false;
	}

	function getTotalShoppingCartValue() external view returns (uint){
		return 500;
	}


	function addToInventory(uint productKey, bytes32 productName, bytes32 productClass, uint quantity , uint costPerUnit, address supplierAddress) public onlyStoreOwner returns (bool){
		return false;
	}

	function removeFromInventory(uint productKey, uint quantity) public onlyStoreOwner  returns (bool){
		return false;

	}
	function getAllProducts() public view returns (bool){
		return false;

	}
	function getTotalInventoryCost() public onlyStoreOwner returns (uint){
		uint totalCost = 500;
		return totalCost;
	}
}

