// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20SnapshotUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "hardhat/console.sol";

contract MSBT is
    Initializable,
    ERC20Upgradeable,
    ERC20BurnableUpgradeable,
    ERC20SnapshotUpgradeable,
    AccessControlUpgradeable,
    PausableUpgradeable
{
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");

    uint256 public cap;
    mapping(address => uint256) private _budgets;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __ERC20_init("MobiFi Soulbound Token", "MSBT");
        __ERC20Burnable_init();
        __ERC20Snapshot_init();
        __AccessControl_init();
        __Pausable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(OWNER_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender); // Owner can grant multiple minter roles, i.e., you can have multiple addresses that can perform minting action.
        _grantRole(SNAPSHOT_ROLE, msg.sender);
        _setRoleAdmin(PAUSER_ROLE, OWNER_ROLE);
        _setRoleAdmin(BURNER_ROLE, OWNER_ROLE);
        _setRoleAdmin(MINTER_ROLE, OWNER_ROLE);
        _setRoleAdmin(SNAPSHOT_ROLE, OWNER_ROLE);

        cap = 1e27;
        _pause();
    }

    function snapshot() public onlyRole(SNAPSHOT_ROLE) {
        _snapshot();
    }

    function getCurrentSnapshotId() public view returns (uint256) {
        return _getCurrentSnapshotId();
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    // set budget to a specific spender (this spender should have minter role as well) and an amount
    function setBudget(address spender, uint256 amount)
        public
        onlyRole(OWNER_ROLE)
    {
        _budgets[spender] = amount;
    }
    // check the remaining budget of the spender (this spender should have minter role as well)
    function budgetOf(address account) public view returns (uint256) {
        return _budgets[account];
    }
    
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        require(amount <= _budgets[msg.sender], "MSBT: insufficient budgets");
        require(totalSupply() + amount <= cap, "MSBT: insufficient MSBTs");
        _budgets[msg.sender] -= amount;
        _mint(to, amount);
    }

    // before any address tries to send token, it will run the check here to see
    // if the user has MINTER_ROLE or BURNER_ROLE, if not, then contract paused. 
    // this function will prevent normal user from sending their tokens, makes it 
    // soulbound.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20Upgradeable, ERC20SnapshotUpgradeable) {
        require(
            hasRole(MINTER_ROLE, msg.sender) ||
                hasRole(BURNER_ROLE, msg.sender) ||
                !paused(),
            "Pausable: paused"
        );
        super._beforeTokenTransfer(from, to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20Upgradeable) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20Upgradeable)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20Upgradeable)
        onlyRole(BURNER_ROLE)
    {
        super._burn(account, amount);
    }
}