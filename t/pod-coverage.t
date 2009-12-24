#!/usr/bin/perl

use strict;
use warnings;
use lib qw(./lib ../lib);

use Test::More;


my $TEST_POD_COVERAGE_VERSION = 1.08;
my $POD_COVERAGE_VERSION      = 0.18;

eval('use Test::Pod::Coverage ' . $TEST_POD_COVERAGE_VERSION);
plan('skip_all' => 'Test::Pod::Coverage ' . $TEST_POD_COVERAGE_VERSION . ' required for testing POD coverage') if $@;

# Test::Pod::Coverage doesn't require a minimum Pod::Coverage version,
# but older versions don't recognize some common documentation styles
eval('use Pod::Coverage ' . $POD_COVERAGE_VERSION);
plan('skip_all' => 'Pod::Coverage ' . $POD_COVERAGE_VERSION . ' required for testing POD coverage') if $@;

all_pod_coverage_ok();
