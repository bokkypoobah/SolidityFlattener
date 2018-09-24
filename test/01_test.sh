#!/bin/sh

echo "----- Generating Flattened SubdirExample_flattened.sol -----"
../solidityFlattener.pl --contractsdir=subdir_contracts --mainsol=SubdirExample.sol --outputsol=SubdirExample_flattened.sol --verbose

echo "----- Differences between flattened SubdirExample_flattened.sol and expected SubdirExample_flattened_expected.sol -----"
diff SubdirExample_flattened.sol SubdirExample_flattened_expected.sol
echo "----- End Differences -----"


echo "----- Generating Flattened MintableToken_flattened.sol -----"
../solidityFlattener.pl --contractsdir=mintabletoken_contracts --mainsol=MintableToken.sol --outputsol=MintableToken_flattened.sol --verbose

echo "----- Differences between flattened MintableToken_flattened.sol and expected MintableToken_flattened_expected.sol -----"
diff MintableToken_flattened.sol MintableToken_flattened_expected.sol
echo "----- End Differences -----"
