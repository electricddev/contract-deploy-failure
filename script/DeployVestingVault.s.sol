// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {VestingVault} from "../src/VestingVault.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract DeployVestingVault is Script {
    function setUp() public {}

    function run() public {
        // vm.broadcast();

        address owner = vm.envAddress("OWNER");
        console.log("owner is %s", owner);

        bytes32 merkleRoot = vm.envBytes32("MERKLE_ROOT");

        uint256 deadline = vm.envUint("DEADLINE");

        uint256 maxPrice = vm.envUint("MAX_PRICE");

        uint256 minPrice = vm.envUint("MIN_PRICE");

        uint256 cliffLength = vm.envUint("CLIFF_LENGTH");

        uint256 maxRedeem = vm.envUint("MAX_REDEEM");

        uint256 pk = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(pk);

        address proxy = Upgrades.deployTransparentProxy(
            "VestingVault.sol",
            vm.envAddress("OWNER"),
            abi.encodeCall(
                VestingVault.initialize, (owner, merkleRoot, deadline, minPrice, maxPrice, cliffLength, maxRedeem)
            )
        );
        console.log("proxy is %s", proxy);
        vm.stopBroadcast();
    }
}
