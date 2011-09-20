#!/usr/bin/env perl
use strict;
use warnings;

use MooseX::Declare;

class SBG::MyModule {
    has 'cache' => (is => 'ro', default => sub { CHI->new(driver=>'Null') } );
    
    method fib (Int $n) {
        # Dont' cache the easy stuff
        return $n if $n < 2;

        # Check cache
        my $cached = $self->cache->get($n);
        return $cached if defined $cached;

        # Recursive call
        my $ans = $self->fib($n-1) + $self->fib($n-2);
        # Cache the answer for next time
        $self->cache->set($n, $ans);
    }
}
