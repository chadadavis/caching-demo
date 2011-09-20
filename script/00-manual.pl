#!/usr/bin/env perl
use strict;
use warnings;

# Manual in memory caching

my %cache;

# Function with a manual memory cache
sub gen_numbers {
    my $n = shift;
    # Check cache
    my $cached = $cache{$n};
    # Verify 
    return $cached if defined $cached;

    # Pretend that this is time-consuming
    sleep 1 + $n / 10;
    # Do some computation
    my $result = [ 0 .. $n ];
    # Cache it
    $cache{$n} = $result;
    return $result;
}

use Benchmark ':all';

# Do it 5 times
timethese 5, {
    manual => sub{for (10,20,30){my $x=gen_numbers($_);print "@$x\n"}}
};

    