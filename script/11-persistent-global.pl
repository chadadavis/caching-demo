#!/usr/bin/env perl
use strict;
use warnings;

# Considering only the persistent global caches

# Caching system
use CHI;


my $cache_net = CHI->new(driver=>'File',
                        # Cache directory for your computer architecture
                        root_dir=>$ENV{CACHEDIR},
                        namespace=>'files-demo',
                        expires_in => '2 weeks',
                        cache_size => '1024m',
                        );

my $memcached = CHI->new(driver=>'Memcached',
                        namespace=>'memcached-demo',
                        servers=>['russelllab.org:11211'], 
                        );
                        

# Works the same as with the hash-based cache, no I/O formatting required
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
    net      =>sub{for (2000,3000){gen_numbers($_,$cache_net)}},
    memcached=>sub{for (2000,3000){gen_numbers($_,$memcached)}},
};

  