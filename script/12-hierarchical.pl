#!/usr/bin/env perl
use strict;
use warnings;

# Caching system
use CHI;

# Recommended general-purpose cache. SBG::U::Cache version 2.0

# A persistent cache, with a non-persistent faster cache in front of it
my $hierarchy = CHI->new(
    # Bottom level cache: 4G,NFS speed,persistent,not parallel
    driver => 'File',
    root_dir=>$ENV{CACHEDIR},
    namespace=>'hierarchical-demo',
    expires_in => '4 weeks',
    cache_size => '4096m',
          
    # Top level cache: runs at memory speed
    l1_cache => { driver=>'Memory',global=>1,cache_size=>'256m'},
    
);

