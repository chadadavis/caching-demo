#!/usr/bin/env perl
use strict;
use warnings;

use CHI;

my $memcached = CHI->new(driver=>'Memcached',
                        namespace=>'memcached-demo',
                        servers=>['russelllab.org:11211'], 
                        );
# Clear cache
$memcached->memd->flush_all;

