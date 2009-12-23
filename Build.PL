use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Log::Log4perl::Config::YAMLConfigurator',
    license             => 'perl',
    dist_author         => q{Denis Ibaev <dionys@cpan.org>},
    dist_version_from   => 'lib/Log/Log4perl/Config/YAMLConfigurator.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Log-Log4perl-Config-YAMLConfigurator-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
