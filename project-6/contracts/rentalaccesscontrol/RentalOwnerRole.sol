pragma solidity >=0.4.24;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'RentalOwnerRole' to manage this role - add, remove, check
contract RentalOwnerRole {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event RentalOwnerAdded(address indexed account);
  event RentalOwnerRemoved(address indexed account);

  // Define a struct 'RentalOwners' by inheriting from 'Roles' library, struct Role
  Roles.Role private rentalOwners;

  // In the constructor make the address that deploys this contract the 1st RentalOwner
  constructor() public {
    _addRentalOwner(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyRentalOwner() {
    require(isRentalOwner(msg.sender));
    _;
  }

  // Define a function 'isRentalOwner' to check this role
  function isRentalOwner(address account) public view returns (bool) {
    return rentalOwners.has(account);
  }

  // Define a function 'addRentalOwner' that adds this role
  function addRentalOwner(address account) public onlyRentalOwner {
    _addRentalOwner(account);
  }

  // Define a function 'renounceRentalOwner' to renounce this role
  function renounceRentalOwner() public {
    _removeRentalOwner(msg.sender);
  }

  // Define an internal function '_addRentalOwner' to add this role, called by 'addRentalOwner'
  function _addRentalOwner(address account) internal {
    rentalOwners.add(account);
    emit RentalOwnerAdded(account);
  }

  // Define an internal function '_removeRentalOwner' to remove this role, called by 'removeRentalOwner'
  function _removeRentalOwner(address account) internal {
    rentalOwners.remove(account);
    emit RentalOwnerRemoved(account);
  }
}