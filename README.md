# Solidity Flattener

Flatten multiple Solidity files into a single Solidity file so:

* You can load your project in http://remix.ethereum.org
* Verify your source code on [etherscan.io](https://etherscan.io/) or [etherchain.org](https://www.etherchain.org)

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

Sample usage on [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-solidity)'s [ERC20Mintable.sol](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Mintable.sol):

```
$ solidityFlattener.pl --contractsdir=contracts --mainsol=token/ERC20/ERC20Mintable.sol --outputsol=/tmp/ERC20Mintable_flattened.sol --verbose
contractsdir: contracts
mainsol     : token/ERC20/ERC20Mintable.sol
outputsol   : /tmp/ERC20Mintable_flattened.sol
Processing contracts/token/ERC20/ERC20Mintable.sol
    Importing contracts/token/ERC20/ERC20.sol
    Processing contracts/token/ERC20/ERC20.sol
        Importing contracts/token/ERC20/IERC20.sol
        Processing contracts/token/ERC20/IERC20.sol
        Importing contracts/token/ERC20/../../math/SafeMath.sol
        Processing contracts/token/ERC20/../../math/SafeMath.sol
    Importing contracts/token/ERC20/../../access/roles/MinterRole.sol
    Processing contracts/token/ERC20/../../access/roles/MinterRole.sol
        Importing contracts/token/ERC20/../../access/roles/../Roles.sol
        Processing contracts/token/ERC20/../../access/roles/../Roles.sol
```

Structure of the generated output file:
```
$ egrep -e "library |contract |interface " /tmp/ERC20Mintable_flattened.sol
interface IERC20 {
library SafeMath {
contract ERC20 is IERC20 {
library Roles {
contract MinterRole {
contract ERC20Mintable is ERC20, MinterRole {
```

The contents of the output can be loaded directly into [Remix](http://remix.ethereum.org/) or used for code verification on the Ethereum block explorers.

<br />

<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd - Sep 24 2018. The MIT Licence.
