#!/usr/bin/env perl
use strict;
use warnings;

# Function with a manual file cache
# Require manual formatting and parsing of the file format
sub gen_numbers {
    my $n = shift;
    # Check cache
    my $cachefile = "/tmp/$n.dat"; 
    if (-e $cachefile) {
        open my $fh, '<',$cachefile;
        # Parse out space-separated numbers
        my $result = [ split ' ', scalar <$fh> ];
        return $result;
    } 

    # Pretend that this is time-consuming
    sleep 1 + $n / 10;
    # Do some computation
    my $result = [ 0 .. $n ];
    # Cache it
    open my $fh, '>', $cachefile;
    # Format data structure output for text file
    print $fh "@$result";
    close $fh;
    return $result;
}

use Benchmark ':all';

# Do it 5 times
timethese 5, {
    manual => sub{for (10,20,30){local $_=gen_numbers($_);print "@$_\n"}}
};
