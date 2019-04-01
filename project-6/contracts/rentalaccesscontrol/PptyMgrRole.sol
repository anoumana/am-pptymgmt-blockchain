pragma solidity >=0.4.24;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'PptyMgrRole' to manage this role - add, remove, check
contract PptyMgrRole {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event PptyMgrAdded(address indexed account);
  event PptyMgrRemoved(address indexed account);

  // Define a struct 'pptyMgrs' by inheriting from 'Roles' library, struct Role
  Roles.Role private pptyMgrs;

  // In the constructor make the address that deploys this contract the 1st PptyMgr
  constructor() public {
    _addPptyMgr(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyPptyMgr() {
    require(isPptyMgr(msg.sender));
    _;
  }

  // Define a function 'isPptyMgr' to check this role
  function isPptyMgr(address account) public view returns (bool) {
    return pptyMgrs.has(account);
  }

  // Define a function 'addPptyMgr' that adds this role
  function addPptyMgr(address account) public onlyPptyMgr {
    _addPptyMgr(account);
  }

  // Define a function 'renouncePptyMgr' to renounce this role
  function renouncePptyMgr() public {
    _removePptyMgr(msg.sender);
  }

  // Define an internal function '_addPptyMgr' to add this role, called by 'addPptyMgr'
  function _addPptyMgr(address account) internal {
    pptyMgrs.add(account);
    emit PptyMgrAdded(account);
  }

  // Define an internal function '_removePptyMgr' to remove this role, called by 'removePptyMgr'
  function _removePptyMgr(address account) internal {
    pptyMgrs.remove(account);
    emit PptyMgrRemoved(account);
  }
}