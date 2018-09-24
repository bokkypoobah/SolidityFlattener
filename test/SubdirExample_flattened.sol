pragma solidity ^0.4.24;



contract Dir02file {
    function returnSomething() public pure returns (uint) {
        return 123;
    }
}

contract Dir01file is Dir02file {
    function returnSomething() public pure returns (uint) {
        return super.returnSomething();
    }
}

contract Main is Dir01file {
    function returnSomething() public pure returns (uint) {
        return super.returnSomething();
    }
}
