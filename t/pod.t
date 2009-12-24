#!/usr/bin/perl

use strict;
use warnings;
use lib qw(./lib ../lib);

use Test::More;


my $TEST_POD_VERSION = 1.22;

eval('use Test::Pod ' . $TEST_POD_VERSION);
plan('skip_all' => 'Test::Pod ' . $TEST_POD_VERSION . ' required for testing POD') if $@;

all_pod_files_ok();
