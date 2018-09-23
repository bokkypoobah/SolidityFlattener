# Solidity Flattener

Flatten multiple Solidity files into a single Solidity file so:

* You can load your project in http://remix.ethereum.org
* Verify your source code on [etherscan.io](https://etherscan.io/) or [etherchain.org](https://www.etherchain.org)

<br />

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
