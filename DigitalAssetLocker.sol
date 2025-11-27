// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DigitalAssetLocker {
    struct Asset {
        string assetHash;
        uint256 timestamp;
    }

    mapping(address => Asset[]) private userAssets;

    // Store asset (prevents duplicates)
    function storeAsset(string memory _assetHash) public {
        for (uint i = 0; i < userAssets[msg.sender].length; i++) {
            require(
                keccak256(bytes(userAssets[msg.sender][i].assetHash)) != keccak256(bytes(_assetHash)),
                "Asset already exists"
            );
        }
        userAssets[msg.sender].push(
            Asset({ assetHash: _assetHash, timestamp: block.timestamp })
        );
    }

    // Get all assets of caller (removed redundant `public` since it's already in mapping)
    function getAssets() public view returns (Asset[] memory) {
        return userAssets[msg.sender];
    }

    // Delete specific asset (by index) with ownership check
    function deleteAsset(uint index) public {
        require(index < userAssets[msg.sender].length, "Invalid index");
        // No need for ownership check here since `userAssets[msg.sender]` is scoped to caller
        userAssets[msg.sender][index] = userAssets[msg.sender][userAssets[msg.sender].length - 1];
        userAssets[msg.sender].pop();
    }
}