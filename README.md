## Prerequisites
Install foundry via [the documentation](https://book.getfoundry.sh/getting-started/installation)

## Steps

### Copy the environment variables
```
cp <.env.andromeda OR .env.sepolia> .env
```

> [!NOTE]
>  
> `RUST_LOG` is set to `trace`, which adds a lot of verbosity, but it's necessary to extract the transaction hash from the logs.

### Insert your private key in the env file
```
export RPC_URL="https://andromeda.metis.io/?owner=1088"
export PRIVATE_KEY="0x"
```


### Deploy the contract
Run:
```
forge create NFT --rpc-url=$RPC_URL --private-key=$PRIVATE_KEY --constructor-args Test TEST --legacy
```

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

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
