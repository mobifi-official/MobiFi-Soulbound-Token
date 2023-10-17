# MobiFi-Soulbound-Token
This is the repo consists of the smart contract codes for MobiFi Soulbound Token (MSBT), which is the a representation of the future MobiFi DAO Governance token. It is a non-transferrable token that can only be earned by contributing to the MobiFi.World Community


# How to run 

Install dependencies
```npm install```

Compile the contracts
```npx hardhat compile```

Deploy the smart contracts
```npm /script/deploy.js```

Verify the smart contracts
```npx hardhat verify --network polygon [contract address you want to verify] "MSBT contract address" "Proxy Admin contract address" "0x8129fc1c”``` 0x8129fc1c is the argument you should use for the _data argument when deploy the TransparencyUpgradeable.sol contract. It is the function selector for the initialize() function in MSBT.sol

``` 
constructor(address _logic, address admin_, bytes memory _data) payable ERC1967Proxy(_logic, _data) {
        assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
        _changeAdmin(admin_);
    }
```