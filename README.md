# Introduction
This is the repo consists of the smart contract codes for MobiFi Soulbound Token (MSBT), which is the a representation of the future MobiFi DAO Governance token. It is a non-transferrable token that can only be earned by contributing to the MobiFi.World Community


# MobiFi-Soulbound-Token
**$MSBT** Token is controlled by Minter Roles, who are granted by the Owner Role of the contract. Owner also setBudget for the minters. Owner doesn’t have control of the minting process, thus we separate the power and prevent the MSBT token being rugged by one person or a small group of people. ➡️

There is only *one owner* role, but there can be multiple Minter role, Burner role, pauser role and Snapshot role. 

We don’t have multiple Owner role, because Owner can also remove other people’s owner role, which is risky. 

😎 **Owner** role will be controlled by @Yudi Xu but replaced by a multi-sig wallet when the community gets bigger. 

🤑 **Minter** role will be assigned to the most active and original teams of the DAO, and will be replaced to multi-sig wallet after that.

📍 **token address**: https://polygonscan.com/token/0x5060C083445822EEcC8ca6686EacF52D21893aeB

Total #MSBT Supply: 1,000,000,000

| Yearly $MSBT Budget    | 50,000,000 |
| ---------------------  | ---------- |
| Quarterly $MSBT Budget | 12,500,000 |
| Monthly $MSBT Budget   | 416,666    |

More information please refer to our Notion page: https://mobifi.notion.site/MobiFi-World-b34cedea831c4f7082ccc3d4d81748f4?pvs=4

# How to run (if you want to give it a try yourself)

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