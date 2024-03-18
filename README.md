There are 2 contracts in this repo:

- [NFT.sol](./src/NFT.sol)
- [VestingVault.sol](./src/VestingVault.sol)

There are times that `VestingVault.sol` does not deploy. We have so far been able to determine that this changes depending on the `optimizer_runs` configuration. Our findings are in the table below.

## Sepolia

|                     |                                                                                VestingVault.sol<br/> (sepolia)                                                                                 |                                                                                     NFT.sol<br/> (sepolia)                                                                                     |
| :-----------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|  Without Optimizer  | ✅ <br/> [0x72d768944813f2a3c409cbb5cbcfa159847d7073f082b2cdf7016bb5d1ef5182](https://sepolia-explorer.metisdevops.link/tx/0x72d768944813f2a3c409cbb5cbcfa159847d7073f082b2cdf7016bb5d1ef5182) | ✅<br/> [0xfccb5e072ef11f5d8ac844c1a36f73e371747640fc2fd203d7e873d9bd4c1ce7](https://sepolia-explorer.metisdevops.link/tx/0xfccb5e072ef11f5d8ac844c1a36f73e371747640fc2fd203d7e873d9bd4c1ce7)  |
| 100k Optimizer Runs |                                               ❌<br/> 0x07470771446028b041dd866f77c5d2ab6299d4b4ecbdc6490ef8ec9f57eaaf24 (dropped from mempool)                                                | ✅<br/> [0x3a08ce74ba1610ab4ace5ecacb26d2cbd539da8f20ef31913c41f555a93350f8](https://sepolia-explorer.metisdevops.link/tx/0x3a08ce74ba1610ab4ace5ecacb26d2cbd539da8f20ef31913c41f555a93350f8)  |
|  1m Optimizer Runs  |                                               ❌ <br/> 0xa896b3a441bffcaa9645be7fe5beb9d221c0fd8238d4c3c4e207f965b95da66b (dropped from mempool)                                               | ✅ <br/> [0x6717c616c5a62f6c75f8965cb4913473e08c23dc848dff6fabd4ede3c68e9fd9](https://sepolia-explorer.metisdevops.link/tx/0x6717c616c5a62f6c75f8965cb4913473e08c23dc848dff6fabd4ede3c68e9fd9) |

## Andromeda

|                     |                                                                            VestingVault.sol<br/> (andromeda)                                                                             |                                                                                     NFT.sol<br/> (andromeda)                                                                                     |
| :-----------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|  Without Optimizer  | ✅ <br/> [0x74ad25f8696f297a231bc04cd1d7b149e27629b7e3db33269b5cad7ec923b6b9](https://andromeda-explorer.metis.io/tx/0x74ad25f8696f297a231bc04cd1d7b149e27629b7e3db33269b5cad7ec923b6b9) |     ✅ <br/> [0xd6524bdd36b6ce130a65a2516701dbe3e56366dc1bf4300a9bb4001a947fbb83](https://andromeda-explorer.metis.io/tx/0xd6524bdd36b6ce130a65a2516701dbe3e56366dc1bf4300a9bb4001a947fbb83)     |
| 100k Optimizer Runs |                                            ❌ <br/> 0xf9fbdd57566440c6e69e86b2b7a70447b2b5305a3e16e7558d861f82d73b2908 (dropped from mempool)                                            | ✅ <br/> [0x38dbfcd59bcb011d3fd82c191060c41c70df85ea31ee42cc419053b6eea7c40c](https://andromeda-explorer.metisdevops.link/tx/0x38dbfcd59bcb011d3fd82c191060c41c70df85ea31ee42cc419053b6eea7c40c) |
|  1m Optimizer Runs  |                                            ❌ <br/> 0xa33f1b532e4003726d4dd57cbeed3bfa11bff70db291ad6b377dbd725574be56 (dropped from mempool)                                            | ✅ <br/> [0x733716aedc88ca8a5a0fa47a81ecc9acb65737a9f901ecd64981e1c454a0b632](https://andromeda-explorer.metisdevops.link/tx/0x733716aedc88ca8a5a0fa47a81ecc9acb65737a9f901ecd64981e1c454a0b632) |

# Replicate the failure

## Prerequisites

Install foundry via [the documentation](https://book.getfoundry.sh/getting-started/installation)

## Steps

### Copy the environment variables

```
cp <.env.andromeda OR .env.sepolia> .env
```

> [!NOTE]
>
> `RUST_LOG` is set to `ethers_providers`, which adds a lot of verbosity, but it's necessary to extract the transaction hash from the logs.

### Insert your private key in the env file

```
export RPC_URL="https://andromeda.metis.io/?owner=1088"
export PRIVATE_KEY="0x"
```

### Deploy the contract

Run:

```
forge create VestingVault --rpc-url=$RPC_URL --private-key=$PRIVATE_KEY --legacy
```

### ✅ Deploy VestingVault (no optimizer)

```
forge create VestingVault --rpc-url=$RPC_URL --private-key=$PRIVATE_KEY --legacy
```

### ✅ Deploy NFT (no optimizer)

```
forge create NFT --rpc-url=$RPC_URL --private-key=$PRIVATE_KEY --legacy --constructor-args hey hey
```

### ❌ Deploy VestingVault (100K optimizer runs)

```
forge create VestingVault --rpc-url=$RPC_URL --private-key=$PRIVATE_KEY --legacy --optimize --optimizer-runs 100000
```

```
DEBUG ethers_providers::toolbox::pending_transaction: Dropped from mempool, pending tx 0x07470771446028b041dd866f77c5d2ab6299d4b4ecbdc6490ef8ec9f57eaaf24
```

### ✅ Deploy NFT (100K optimizer runs)

```
forge create NFT --rpc-url=$RPC_URL --private-key=$PRIVATE_KEY --legacy --constructor-args hey hey --optimize --optimizer-runs 100000
```

### ❌ Deploy VestingVault (1m optimizer runs)

```
forge create VestingVault --rpc-url=$RPC_URL --private-key=$PRIVATE_KEY --legacy --optimize --optimizer-runs 1000000
```

```
DEBUG ethers_providers::toolbox::pending_transaction: Dropped from mempool, pending tx 0xa896b3a441bffcaa9645be7fe5beb9d221c0fd8238d4c3c4e207f965b95da66b
```

### ✅ Deploy NFT (1m optimizer runs)

```
forge create NFT --rpc-url=$RPC_URL --private-key=$PRIVATE_KEY --legacy --constructor-args hey hey --optimize --optimizer-runs 1000000
```

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
