#!/usr/bin/env perl
use strict;
use warnings;

# Need to define the variable before loading the library in this case
# But don't be tempted to define this in your shell. Your browser would use it
BEGIN { 
    $ENV{http_proxy} = "http://russelllab.org:3128" unless defined $ENV{http_proxy};
}
use LWP::Simple;


use Benchmark ':all';

# Name of this test
my $proxy = $ENV{http_proxy} ? 'withproxy' : 'noproxy';

timethese 3, {
    $proxy => sub{get "http://www.w3.org/TR/2001/REC-xsl-20011015/xslspec.xml"}
};

