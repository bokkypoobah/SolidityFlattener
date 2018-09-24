import "../dir02/Dir02file.sol";

contract Dir01file is Dir02file {
    function returnSomething() public pure returns (uint) {
        return super.returnSomething();
    }
}
