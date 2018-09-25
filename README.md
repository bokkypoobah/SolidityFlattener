# Solidity Flattener

Flatten multiple Solidity files into a single Solidity file so you can:

* load your project in http://remix.ethereum.org
* verify your source code on [etherscan.io](https://etherscan.io/) or [etherchain.org](https://www.etherchain.org)

This Solidity Flattener was created for easy inclusion into your Solidity project, and to incorporate it into your build scripts.

<br />

<hr />

## History

Version | Date | Notes
:------ |:---- |:-----
v1.0.0  | Sep 24 2018 | First version
v1.0.1  | Sep 24 2018 | Ability to remap directory to handle OpenZeppelin npm installation

<br />

<hr />

## Installation

* Download [solidityFlattener.pl](solidityFlattener.pl) into `/usr/local/bin`, or into your Solidity project `scripts` folder
* `chmod 755 /usr/local/bin/solidityFlattener.pl` or adjust for your download location

<br />

<hr />

## Usage

```
Solidity Flattener v1.0.1

Usage: solidityFlattener.pl {options}

Where options are:
  --contractsdir  Source directory for original contracts. Default './contracts'
  --remapdir      Remap import directories. Optional. Example "contracts/openzeppelin-solidity=node_modules/openzeppelin-solidity"
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

### Example 1 - Contracts In Subdirectories

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

to produce the flattened file [test/SubdirExample_flattened.sol](test/SubdirExample_flattened.sol):

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

<hr />

### Example 2 - Simple MintableToken

Main Solidity file [test/mintabletoken_contracts/MintableToken.sol](test/mintabletoken_contracts/MintableToken.sol).

From the [test](test) subdirectory, run the following command:

```bash
test $ solidityFlattener.pl --contractsdir=mintabletoken_contracts --mainsol=MintableToken.sol --outputsol=MintableToken_flattened.sol --verbose
contractsdir: mintabletoken_contracts
mainsol     : MintableToken.sol
outputsol   : MintableToken_flattened.sol
Processing mintabletoken_contracts/MintableToken.sol
    Importing mintabletoken_contracts/SafeMath.sol
    Processing mintabletoken_contracts/SafeMath.sol
    Importing mintabletoken_contracts/MintableTokenInterface.sol
    Processing mintabletoken_contracts/MintableTokenInterface.sol
        Importing mintabletoken_contracts/ERC20Interface.sol
        Processing mintabletoken_contracts/ERC20Interface.sol
    Importing mintabletoken_contracts/Owned.sol
    Processing mintabletoken_contracts/Owned.sol
```

To produce the flattened file [test/MintableToken_flattened.sol](test/MintableToken_flattened.sol).

<br />

<hr />

### Example 3 - MintableToken With OpenZeppelin Npm Mapping

Main Solidity file [test/oz_contracts/MyOzToken.sol](test/oz_contracts/MyOzToken.sol), with [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-solidity) installed in `../private/node_modules/openzeppelin-solidity`.

From the [test](test) subdirectory, run the following command:

```bash
test $ solidityFlattener.pl --contractsdir=oz_contracts --remapdir "oz_contracts/openzeppelin-solidity=../private/node_modules/openzeppelin-solidity" --mainsol=MyOzToken.sol --verbose
contractsdir: oz_contracts
remapdir    : oz_contracts/openzeppelin-solidity=../private/node_modules/openzeppelin-solidity
mainsol     : MyOzToken.sol
outputsol   : MyOzToken_flattened.sol
Processing oz_contracts/MyOzToken.sol
    Importing oz_contracts/openzeppelin-solidity/contracts/math/SafeMath.sol
    Remapping oz_contracts/openzeppelin-solidity/contracts/math/SafeMath.sol
           to ../private/node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
    Processing ../private/node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
    Importing oz_contracts/openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
    Remapping oz_contracts/openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
           to ../private/node_modules/openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
    Processing ../private/node_modules/openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
        Importing ../private/node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
        Processing ../private/node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
            Importing ../private/node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
            Processing ../private/node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
                Importing ../private/node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
                Processing ../private/node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
                Already Imported ../private/node_modules/openzeppelin-solidity/contracts/token/ERC20/../../math/SafeMath.sol
            Importing ../private/node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
            Processing ../private/node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
                Already Imported ../private/node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
        Importing ../private/node_modules/openzeppelin-solidity/contracts/token/ERC20/../../ownership/Ownable.sol
        Processing ../private/node_modules/openzeppelin-solidity/contracts/token/ERC20/../../ownership/Ownable.sol
```

To produce the flattened file [test/MyOzToken_flattened.sol](test/MyOzToken_flattened.sol).

<br />

<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd - Sep 24 2018. The MIT Licence.
