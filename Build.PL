#!/usr/bin/perl

use strict;
use warnings;

use Module::Build;


my $builder = Module::Build->new(
	'module_name'        => 'Log::Log4perl::Config::YAMLConfigurator',
	'dist_abstract'      => 'Parser of Log::Log4perl configuration files based on YAML syntax',
	'license'            => 'perl',
	'dist_author'        => q(Denis Ibaev <dionys@cpan.org>),
	'dist_version_from'  => 'lib/Log/Log4perl/Config/YAMLConfigurator.pm',
	'build_requires'     => {
		'Test::More'                              => 0,
	},
	'requires'           => {
		'perl'                                    => '5.008',
		'parent'                                  => 0,
		'Hash::Merge'                             => 0,
		'Log::Log4perl::Config'                   => 0,
		'Log::Log4perl::Config::BaseConfigurator' => 0,
		'YAML'                                    => 0,
	},
	'recommends'         => {
		'YAML::Syck'                              => 0,
	},
	meta_merge           => {
		'resources' => {
			'repository' => 'http://github.com/dionys/log-log4perl-config-yamlconfigurator',
		},
		'keywords'  => [
			'log',
			'log4perl',
			'yaml',
		],
	},
	'add_to_cleanup'     => ['Log-Log4perl-Config-YAMLConfigurator-*'],
	'create_makefile_pl' => 'traditional',
);

$builder->create_build_script();
