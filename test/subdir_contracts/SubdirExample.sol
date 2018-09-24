pragma solidity ^0.4.24;

import "dir01/Dir01file.sol";
import "dir01/Dir02file.sol";

contract Main is Dir01file {
    function returnSomething() public pure returns (uint) {
        return super.returnSomething();
    }
}
