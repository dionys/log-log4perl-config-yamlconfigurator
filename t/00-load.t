#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Log::Log4perl::Config::YAMLConfigurator' ) || print "Bail out!
";
}

diag( "Testing Log::Log4perl::Config::YAMLConfigurator $Log::Log4perl::Config::YAMLConfigurator::VERSION, Perl $], $^X" );
