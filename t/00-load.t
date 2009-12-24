#!/usr/bin/perl

use strict;
use warnings;
use lib qw(./lib ../lib);

use Test::More (tests => 1);


BEGIN
{
    use_ok('Log::Log4perl::Config::YAMLConfigurator');
}
