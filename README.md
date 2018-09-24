# Solidity Flattener

Flatten multiple Solidity files into a single Solidity file so you can:

* load your project in http://remix.ethereum.org
* verify your source code on [etherscan.io](https://etherscan.io/) or [etherchain.org](https://www.etherchain.org)

This Solidity Flattener was created for easy inclusion into your Solidity project, and to incorporate it into your build scripts.

<br />

<hr />

## Usage

```
Solidity Flattener v1.0.0

Usage: solidityFlattener.pl {options}

Where options are:
  --contractsdir  Source directory for original contracts. Default './contracts'.
  --mainsol       Main source Solidity file. Mandatory
  --outputsol     Output flattened Solidity file. Default is mainsol with `_flattened` appended to the file name
  --verbose       Show details. Optional
  --help          Display help. Optional

Example usage:
  solidityFlattener.pl --contractsdir=contracts --mainsol=MyContract.sol --outputsol=flattened/MyContracts_flattened.sol --verbose

Installation:
  Download solidityFlattener.pl from https://github.com/bokkypoobah/SolidityFlattener into /usr/local/bin
  chmod 755 /usr/local/bin/solidityFlattener.pl

Works on OS/X, Linux and Linux on Windows.

Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
```

<br />

<hr />

## Sample Usage

See the examples in the [test](test) subdirectory, one of which is shown below.

Main Solidity file [test/subdir_contracts/SubdirExample.sol](test/subdir_contracts/SubdirExample.sol):

```solidity
pragma solidity ^0.4.24;

import "dir01/Dir01file.sol";
import "dir01/Dir02file.sol";

contract Main is Dir01file {
    function returnSomething() public pure returns (uint) {
        return super.returnSomething();
    }
}
```

First import file [test/subdir_contracts/dir01/Dir01file.sol](test/subdir_contracts/dir01/Dir01file.sol):

```solidity
pragma solidity ^0.4.24;

import "../dir02/Dir02file.sol";

contract Dir01file is Dir02file {
    function returnSomething() public pure returns (uint) {
        return super.returnSomething();
    }
}
```

Second import file [test/subdir_contracts/dir02/Dir02file.sol](test/subdir_contracts/dir02/Dir02file.sol):

```solidity
pragma solidity ^0.4.24;

contract Dir02file {
    function returnSomething() public pure returns (uint) {
        return 123;
    }
}
```

From the [test](test) subdirectory, run the following command:

```bash
test $ solidityFlattener.pl --contractsdir=subdir_contracts --mainsol=SubdirExample.sol --outputsol=SubdirExample_flattened.sol --verbose
contractsdir: subdir_contracts
mainsol     : SubdirExample.sol
outputsol   : SubdirExample_flattened.sol
Processing subdir_contracts/SubdirExample.sol
    Importing subdir_contracts/dir01/Dir01file.sol
    Processing subdir_contracts/dir01/Dir01file.sol
        Importing subdir_contracts/dir01/../dir02/Dir02file.sol
        Processing subdir_contracts/dir01/../dir02/Dir02file.sol
    Already Imported subdir_contracts/dir01/Dir02file.sol
```

To produce the flattened file [test/SubdirExample_flattened.sol](test/SubdirExample_flattened.sol):

```solidity
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
```

The contents of the output can be loaded directly into [Remix](http://remix.ethereum.org/) or used for code verification on the Ethereum block explorers.

<br />

<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd - Sep 24 2018. The MIT Licence.
