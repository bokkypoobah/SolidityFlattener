#!/usr/bin/perl -W
# ----------------------------------------------------------------------------------------------
# Solidity Flattener
#
# https://github.com/bokkypoobah/SolidityFlattener
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
# ----------------------------------------------------------------------------------------------

use strict;
use Getopt::Long qw(:config no_auto_abbrev);

my $DEFAULTCONTRACTSDIR = "./contracts";

my $helptext = qq\
Solidity Flattener v1.0 Sep 24 2018. https://github.com/bokkypoobah/SolidityFlattener

Usage: $0 {options}

Options are:
  --contractsdir  Source directory for original contracts. Default '$DEFAULTCONTRACTSDIR'.
  --mainsol       Main source Solidity file. Mandatory
  --outputsol     Output flattened Solidity file. Default is the mainsol with `_flattened` appended to the file name
  --verbose       Show details. Optional
  --help          Display help. Optional

Example usage:
  $0 --contractsdir=contracts --mainsol=MyContract.sol --outputsol=flattened/MyContracts_flattened.sol --verbose

Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.

Stopped\;

my ($contractsdir, $mainsol, $outputsol, $help, $verbose);
my %seen = ();

GetOptions(
  "contractsdir:s" => \$contractsdir,
  "mainsol:s"      => \$mainsol,
  "outputsol:s"    => \$outputsol,
  "verbose"        => \$verbose,
  "help"           => \$help)
or die $helptext;

die $helptext
  if defined $help;

die $helptext
  unless defined $mainsol;

$contractsdir = $DEFAULTCONTRACTSDIR
  unless defined $contractsdir;

if (!defined $outputsol) {
  $outputsol = $mainsol;
  $outputsol =~ s/\.sol/_flattened\.sol/g;
}

if (defined $verbose) {
  printf "contractsdir: %s\n", $contractsdir;
  printf "mainsol     : %s\n", $mainsol;
  printf "outputsol   : %s\n", $outputsol
}

open OUTPUT, ">$outputsol"
  or die "Cannot open $outputsol for writing. Stopped";

processSol($mainsol, 0);

close OUTPUT
  or die "Cannot close $outputsol. Stopped";

exit;

# ------------------------------------------------------------------------------
# Process Solidity file
# ------------------------------------------------------------------------------
sub processSol {
  my ($sol, $level) = @_;
  $seen{$sol} = 1;
  printf "%sProcessing %s/%s\n", "  " x $level, $contractsdir, $sol
    if defined $verbose;

  open INPUT, "<$contractsdir/$sol"
    or die "Cannot open $sol for reading. Stopped";
  my @lines = <INPUT>;
  close INPUT
    or die "Cannot close $outputsol. Stopped";

  for my $line (@lines) {
    chomp $line;
    if ($line =~ /^import/) {
      my $importfile = $line;
      $importfile =~ s/import \"//;
      $importfile =~ s/\";//;
      if ($seen{$importfile}) {
        printf "%s  Already Imported %s\n", "  " x $level, $importfile
          if defined $verbose;
      } else {
        printf "%s  Importing %s\n", "  " x $level, $importfile
          if defined $verbose;
        processSol($importfile, $level + 1)
      }
    } else {
      if ($level == 0 || !($line =~ /^pragma/)) {
        printf OUTPUT "%s\n", $line;
      }
    }
  }
}
