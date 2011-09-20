#!/usr/bin/env perl
use strict;
use warnings;

use CHI;

my $memcached = CHI->new(driver=>'Memcached',
                        namespace=>'memcached-demo',
                        servers=>['russelllab.org:11211'], 
                        );

sub gen_numbers {
    my ($n, $cache) = @_;
    # Check cache
    my $cached = $cache->get($n);
    # Verify 
    return $cached if defined $cached;
    print "$n\tNot cached\n";
    # Pretend that this is time-consuming
    sleep 1 + $n / 1000;
    # Do some computation
    my $result = [ 0 .. $n ];
    # Cache it
    $cache->set($n, $result);
    return $result;
}
                        
use Benchmark ':all';              

timethese 10_000, {
    memcached=>sub{for (2000,3000){gen_numbers($_,$memcached)}},
};
  