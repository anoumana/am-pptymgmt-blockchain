pragma solidity >=0.4.24;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'CleaningCompRole' to manage this role - add, remove, check
contract CleaningCompRole {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event CleaningCompAdded(address indexed account);
  event CleaningCompRemoved(address indexed account);

  // Define a struct 'cleaningComps' by inheriting from 'Roles' library, struct Role
  Roles.Role private cleaningComps;

  // In the constructor make the address that deploys this contract the 1st CleaningComp
  constructor() public {
    _addCleaningComp(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyCleaningComp() {
    require(isCleaningComp(msg.sender));
    _;
  }

  // Define a function 'isCleaningComp' to check this role
  function isCleaningComp(address account) public view returns (bool) {
    return cleaningComps.has(account);
  }

  // Define a function 'addCleaningComp' that adds this role
  function addCleaningComp(address account) public onlyCleaningComp {
    _addCleaningComp(account);
  }

  // Define a function 'renounceCleaningComp' to renounce this role
  function renounceCleaningComp() public {
    _removeCleaningComp(msg.sender);
  }

  // Define an internal function '_addCleaningComp' to add this role, called by 'addCleaningComp'
  function _addCleaningComp(address account) internal {
    cleaningComps.add(account);
    emit CleaningCompAdded(account);
  }

  // Define an internal function '_removeCleaningComp' to remove this role, called by 'removeCleaningComp'
  function _removeCleaningComp(address account) internal {
    cleaningComps.remove(account);
    emit CleaningCompRemoved(account);
  }
}