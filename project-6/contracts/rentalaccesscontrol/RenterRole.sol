pragma solidity >=0.4.24;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'RenterRole' to manage this role - add, remove, check
contract RenterRole {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event RenterAdded(address indexed account);
  event RenterRemoved(address indexed account);

  // Define a struct 'renters' by inheriting from 'Roles' library, struct Role
  Roles.Role private renters;

  // In the constructor make the address that deploys this contract the 1st Renter
  constructor() public {
    _addRenter(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyRenter() {
    require(isRenter(msg.sender));
    _;
  }

  // Define a function 'isRenter' to check this role
  function isRenter(address account) public view returns (bool) {
    return renters.has(account);
  }

  // Define a function 'addRenter' that adds this role
  function addRenter(address account) public onlyRenter {
    _addRenter(account);
  }

  // Define a function 'renounceRenter' to renounce this role
  function renounceRenter() public {
    _removeRenter(msg.sender);
  }

  // Define an internal function '_addRenter' to add this role, called by 'addRenter'
  function _addRenter(address account) internal {
    renters.add(account);
    emit RenterAdded(account);
  }

  // Define an internal function '_removeRenter' to remove this role, called by 'removeRenter'
  function _removeRenter(address account) internal {
    renters.remove(account);
    emit RenterRemoved(account);
  }
}