# Supply chain - AM Property Management
AM Property Management is a contract where a rental property owner can subscribe to a property mgr and cleaning company. 
They pay the subscription amount using the "subscribe" method and "registerRental" method to register the rental property information. This will put the rental property to "InMarket" state ready and available to be booked by retners.
`subscribe(string  _rentalName, address _pptyMgrID, address _cleaningCompanyID) public payable `
`registerRental(uint _rentalID,  string  rentalAddress, string  rentalNotes, uint rentalPricePerDay)`

Renters use "bookRental" function to book the rental property and changes the state of the property to "Rented". You pay the rental amount based on the # of days the rental property is being rented.
`bookRental(uint _rentalID, uint _rentalDays)`

Cleaning is scheduled using "scheduleAppointment" method and the state changes to "CleaningScheduled"
`scheduleAppointment(uint _rentalID)`

Clean method is called after the property is cleaned and this will change the state of the property to "Cleaned"
`cleanRental(uint _rentalID)`

When the renter checks in to property, checkIn method is called which will change the state of the propoerty to "Occupied"
`checkIn(uint _rentalID)`

When the renter checks out of the property, checkOut method is called which will put the property to state back to "InMarket" ready for renters to book the rental property.
`checkOut(uint _rentalID)`

getRentalPptyInfo method gets therentlaNname, retnalAddress, rentalNotes, rentalState and rentalPricePerDay of the rental ppty 
`getRentalPptyInfo(uint _rentalID)`

## Project - UML
Check uml folder for the UML Documentation in GitHub

## Libraries used in this project
 - jquery 
 - web3 
 - truffle

## IPFS
The website is deployed using IPFS - You can see the website as deployed at https://gateway.ipfs.io/ipfs/Qmd8muEpZc7uVdQbb75CoFpDdrY14TiZiAwvoKE8iHYpcm/

## Other Project Details:
 - Truffle v5.0.4 (core: 5.0.4) 
 - Solidity - 0.4.24 (solc-js) 
 - Node v10.13.0

Contract address (Value Chain): 0x84F276c0fd48a3b4aA2f694B5a1880A085d2b4ce