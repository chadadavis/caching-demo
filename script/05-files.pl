#!/usr/bin/env perl
use strict;
use warnings;

# Caching system
use CHI;

# File cache in /tmp (most useful on single computer, e.g. webserver)
my $cache_tmp = CHI->new(driver=>'File',
#                        root_dir=>'/tmp', # default: /tmp/chi-driver-file
                        namespace=>'files-demo',
                        # /tmp is purged by the OS after 30 days by default
                        expires_in => '2 weeks',
                        cache_size => '1024m',
                        );

# File cache in $CACHEDIR (network file system)
my $cache_net = CHI->new(driver=>'File',
                        # Cache directory for your computer architecture
                        root_dir=>$ENV{CACHEDIR},
                        namespace=>'files-demo',
                        expires_in => '2 weeks',
                        cache_size => '1024m',
                        );
                        

# Works the same as with the hash-based cache, 
# No I/O formatting required for complex data
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
    net=>sub{for (2000,3000){gen_numbers($_,$cache_net)}},
    tmp=>sub{for (2000,3000){gen_numbers($_,$cache_tmp)}},
};
  