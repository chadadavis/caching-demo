#!/usr/bin/env perl
use strict;
use warnings;
use CHI;
my $cache = CHI->new(driver=>'Memory', cache_size=>'256m', global=>1);

# Count ATOM lines for a PDBID (some IDs may be invalid/non-existent)
sub count_atoms {
    # Random PDB ID - simulates occasional bad input
    my $rand = ('a'..'z')[int rand 26];
    my $pdbid = "1${rand}${rand}x";
    # Check cache
    my $cached = $cache->get($pdbid);
    # Might also be a negative hit, caller of this func responsible for checking
    if (defined $cached) {
        print STDERR '+';
        return $cached;
    }
    # Look for a file
    my $path = "$ENV{DS}/pdb-flat/$pdbid.pdb";
    my $lines; 
    unless (-e $path ) {
        # Non-existant ID, negative cache it, with something out of range
        my $lines = -1; # Any sentinel value that cannot otherwise occur
        $cache->set($pdbid, $lines);
        print STDERR '-'
    } else {
        # File exists, do the work, cache it
        $lines = `grep -n '^ATOM' $path`;
        chomp $lines;
        $cache->set($pdbid, $lines);
        print STDERR '0';
    }
    return $lines;
}

use Benchmark ':all';
timethese 1000, {
    count_atoms => sub { count_atoms },
};

