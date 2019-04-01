pragma solidity >=0.4.24;

// Define a contract 'Supplychain'
contract SupplyChain {

  // Define 'owner'
  address payable owner;

  // rentalID 
  uint rentalID = 0;
  uint subscriptionPrice = 100;

  // Define a public mapping 'rentals' that maps the rentalID to a Rental.
  mapping (uint => Rental) rentals;

  // Define enum 'State' with the following values:
  enum State 
  { 
    InMarket,               //0
    Rented,                 //1
    CleaningScheduled,      //2
    Cleaned ,               //3
    Occupied                //4
  }

  State constant defaultRentalState = State.InMarket;

  mapping (address => bool) subscribers;

  // Define a struct 'Rental' with the following fields:
  struct Rental {
    string rentalName;
    uint  rentalID;
    string rentalAddress;
    string rentalNotes;
    State rentalState;
    uint rentalPricePerDay;
    address payable rentalOwnerID;

    address payable renterID;
    uint rentalDays;

    address pptyMgrID;

    address cleaningCompanyID;

  }
 
  event InMarket(uint rentalID);
  event Rented(uint rentalID);
  event CleaningScheduled(uint rentalID);
  event Cleaned(uint rentalID);
  event Occupied(uint rentalID);

  // Define a modifer that checks to see if msg.sender == owner of the contract
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  // Define a modifer that checks to see if msg.sender == subscriber of the rental
  modifier onlySubscriber() {
    require(subscribers[msg.sender]);
    _;
  }

  // Define a modifer that checks to see if the rental ppty is already registered
  modifier onlyRegisteredRental(uint _rentalID) {
    require(rentals[_rentalID].rentalID == _rentalID);
    _;
  }

  // Define a modifer that checks to see if msg.sender != subscriber of the rental
  modifier alreadyNotSubscribed() {
    require(!subscribers[msg.sender]);
    _;
  }

  // Define a modifer that checks to see if msg.sender == subscriber of the rental
  modifier alreadySubscribed() {
    require(subscribers[msg.sender]);
    _;
  }

  // Define a modifer that verifies the Caller
  modifier verifyCaller (address _address) {
    require(msg.sender == _address); 
    _;
  }

  // Define a modifer that verifies the Renter
  modifier verifyRenter (uint _rentalID) {
    require(rentals[_rentalID].renterID == msg.sender); 
    _;
  }

  // Define a modifier that checks if the paid amount is sufficient to cover the price
  modifier paidEnough(uint _price) { 
    require(msg.value >= _price); 
    _;
  }
  
  // Define a modifier that checks the rental price for the rental duration and refunds the remaining balance
  modifier checkRentalValue(uint _rentalID) {
    _;
    uint price = rentals[_rentalID].rentalPricePerDay;

    //Get the rental dates
    uint totalRentalDays = rentals[_rentalID].rentalDays;

    uint totalPrice = totalRentalDays*price;

    uint amountToReturn = msg.value - totalPrice;
    rentals[_rentalID].renterID.transfer(amountToReturn);
  }

  //Assuming all rentals have same subscription price
  modifier checkSubscriptionValue() {
    _;
    //uint amountToReturn = msg.value - rentals[_rentalID].subscriptionPrice;
    uint amountToReturn = msg.value - subscriptionPrice;
    msg.sender.transfer(amountToReturn);
  }


  // Define a modifier that checks if rental is available for Rental
  modifier inMarket(uint _rentalID) {
    require(rentals[_rentalID].rentalState == State.InMarket);
    _;
  }

  // Define a modifier that checks if rental is Rented
  modifier rented(uint _rentalID) {
    require(rentals[_rentalID].rentalState == State.Rented);
    _;
  }

  // Define a modifier that checks if rental is scheduled for cleaning
  modifier cleaningScheduled(uint _rentalID) {
    require(rentals[_rentalID].rentalState == State.CleaningScheduled);
    _;
  }

  // Define a modifier that checks if rental is Cleaned
  modifier cleaned(uint _rentalID) {
    require(rentals[_rentalID].rentalState == State.Cleaned);
    _;
  }

   // Define a modifier that checks if rental is Occupied
  modifier occupied(uint _rentalID) {
    require(rentals[_rentalID].rentalState == State.Occupied);
    _;
  }
 
  // In the constructor set 'owner' to the address that instantiated the contract
    constructor() public payable {
    owner = msg.sender;
  }

  // Define a function 'kill' if required
  function kill() public {
    if (msg.sender == owner) {
      selfdestruct( owner);
    }
  }

    // Define a function 'subscribe' that allows the Rental owner to subscribe to pptymgr
  // Use the above defined modifiers to check if the rental owner is already a subscriber,  the SubscriptionValue , 
  // and any excess ether sent is refunded back to the rental owner
  function subscribe(string  memory _rentalName, address _pptyMgrID, address _cleaningCompanyID) public payable 
    // Call modifer to send any excess ether back to buyer
    checkSubscriptionValue 
  returns (uint rentID)
  {
      // Add the rental owner to the subscriber list
      subscribers[msg.sender] = true;

      rentalID++;
      //Add rentals
      Rental memory rental;
      rental.rentalID = rentalID;
      rental.rentalName = _rentalName;
      rental.pptyMgrID = _pptyMgrID;
      rental.cleaningCompanyID = _cleaningCompanyID;
      rental.rentalState = State.InMarket;

      rentals[rentalID] = rental;

      emit InMarket(rentalID);
      return rentalID;
  }

  function registerRental(uint _rentalID,  string memory rentalAddress, string memory rentalNotes,
                      uint rentalPricePerDay) public  
    // Call modifier to make sure not an existing subscriber
    alreadySubscribed
    onlyRegisteredRental(_rentalID)
  {
      //Update rentals
      Rental memory rental = rentals[_rentalID];
      rental.rentalAddress = rentalAddress;
      rental.rentalNotes = rentalNotes;
      rental.rentalPricePerDay = rentalPricePerDay;
      rental.rentalState = State.InMarket;

      emit InMarket(_rentalID);
      rentals[_rentalID] = rental;

  }

  // Book rentals
  function bookRental(uint _rentalID, uint _rentalDays) public payable 
    // call modifier to make sure this rental ppty is already registered
    onlyRegisteredRental(_rentalID)
    // Call modifier to make sure not an existing subscriber
     inMarket(_rentalID)
    // Call modifer to send any excess ether back to buyer
    checkRentalValue(_rentalID)
  {
      // Add the rental owner to the subscriber list
      rentals[_rentalID].renterID = msg.sender;
      rentals[_rentalID].rentalDays = _rentalDays;
      rentals[_rentalID].rentalState = State.Rented;

      emit Rented(_rentalID);
      
  }

  // Schedule Cleaning Appointment
  function scheduleAppointment(uint _rentalID) public  
    // call modifier to make sure this rental ppty is already registered
    onlyRegisteredRental(_rentalID)
    // Call modifier to make sure not an existing subscriber
     rented(_rentalID)
  {
      // Add the rental owner to the subscriber list
      //rentals[_rentalID].cleaningDate = cleaningDate;
      rentals[_rentalID].rentalState = State.CleaningScheduled;

      emit CleaningScheduled(_rentalID);
      
  }

  // Clean the rental
  function cleanRental(uint _rentalID) public  
    // call modifier to make sure this rental ppty is already registered
    onlyRegisteredRental(_rentalID)
    // Call modifier to make sure its scheduled for cleaning
     cleaningScheduled(_rentalID)
  {
      rentals[_rentalID].rentalState = State.Cleaned;
      emit Cleaned(_rentalID);
      
  }

  // Checkin
  function checkIn(uint _rentalID) public  
    // call modifier to make sure this rental ppty is already registered
    onlyRegisteredRental(_rentalID)
    //Verify the renter is checking in
    verifyRenter(_rentalID)
    // Call modifier to make sure its cleaned 
     cleaned(_rentalID)
  {
      rentals[_rentalID].rentalState = State.Occupied;
      emit Occupied(_rentalID);
  }

  // CheckOut
  function checkOut(uint _rentalID) public  
    // call modifier to make sure this rental ppty is already registered
    onlyRegisteredRental(_rentalID)
    //Verify the renter is checking out
    verifyRenter(_rentalID)
    // Call modifier to make sure its occupied 
     occupied(_rentalID)
  {
      rentals[_rentalID].rentalDays = 0;
      rentals[_rentalID].renterID = address(0);

      rentals[_rentalID].rentalState = State.InMarket;
      emit InMarket(_rentalID);
  }

  // Define a function 'getRentalInfo' that fetches the data
  function getRentalPptyInfo(uint _rentalID) public view 
    // call modifier to make sure this rental ppty is already registered
    onlyRegisteredRental(_rentalID)
  returns 
  (
    string memory rentalName,
    string memory rentalAddress,
    string memory rentalNotes,
    string memory rentalState,
    uint rentalPricePerDay
  ) 
  {
    
    string memory rentalStateString = "Default";
    Rental memory rental = rentals[_rentalID];

    if(rental.rentalState == State.InMarket)
      rentalStateString = "In Market";
    else if(rental.rentalState == State.Rented)
      rentalStateString = "Rented";
    else if(rental.rentalState == State.CleaningScheduled)
      rentalStateString = "Cleaning Scheduled";
    else if(rental.rentalState == State.Cleaned)
      rentalStateString = "Cleaned";
    else if(rental.rentalState == State.Occupied)
      rentalStateString = "Occupied";

    return 
    (
      rental.rentalName,
      rental.rentalAddress,
      rental.rentalNotes,
      rentalStateString,
      rental.rentalPricePerDay
    );
  }

  // Define a function 'getRentalInfo' that fetches the data
  function getRentalOrgInfo(uint _rentalID) public view returns 
  (
    address payable rentalOwnerID,
    address payable renterID,
    address pptyMgrID,
    uint _subscriptionPrice,
    address cleaningCompanyID
  ) 
  {
    
    Rental memory rental = rentals[_rentalID];

    return 
    (
      rentals[_rentalID].rentalOwnerID,
      rental.renterID,
      rental.pptyMgrID,
      subscriptionPrice,
      rental.cleaningCompanyID
    );
  }

  // Define a function 'getRentalInfo' that fetches the data
  function getRentalCheckInInfo(uint _rentalID) public view returns 
  (
    string memory rentalName,
    address payable rentalOwnerID,
    address payable renterID,
    uint rentalDays
  ) 
  {
    
    Rental memory rental = rentals[_rentalID];

    return 
    (
      rental.rentalName,
      rental.rentalOwnerID,
      rental.renterID,
      rental.rentalDays
    );
  }
}
