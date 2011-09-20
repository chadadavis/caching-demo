#!/usr/bin/env perl
use strict;
use warnings;

use CHI;

# Find my modules
use FindBin;
use lib "$FindBin::Bin/../lib";
use SBG::MyModule;

# Object does no caching by default
my $object_null  = SBG::MyModule->new;

# Externally created cache object. The module doesn't care what type it is
my $cache = CHI->new(driver=>'Memory', global=>1, cache_size=>'512m');

# Create the object, with the cache of my choice
my $object_cache = SBG::MyModule->new(cache=>$cache);

use Benchmark ':all';
timethese 5, {
    cache => sub { $object_cache->fib(20) },
    null  => sub { $object_null->fib(20) },
}
