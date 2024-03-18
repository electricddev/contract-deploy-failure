// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import { NFT } from "../src/NFT.sol";

contract DeployNFT is Script {
    function setUp() public {}

    function run() public {
        // vm.broadcast();


        uint256 pk = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(pk);

		NFT nft = new NFT("hey", "HEY");

        console.log("nft is %s", address(nft));
        vm.stopBroadcast();
    }
}
