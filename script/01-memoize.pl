#!/usr/bin/env perl
use strict;
use warnings;

# Automatic in-memory caching

# Compute Fibonacci numbers
sub fib {
    my $n = shift;
    return $n if $n < 2;
    fib($n-1) + fib($n-2);
}

# Provide cache for single function
use Memoize;

# Measure the difference
use Benchmark ':all';

# Argument to Fibonacci
my $arg = 30;
# Test it $tests times
my $tests = 5;

# Measure
timethese( $tests, {
    a_nocache => sub {                 print fib($arg), "\n"; },
    b_wcache  => sub { memoize('fib'); print fib($arg), "\n"; },
    });
    
    
