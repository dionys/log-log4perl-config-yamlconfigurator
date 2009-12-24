package Log::Log4perl::Config::YAMLConfigurator;

use warnings;
use strict;

use parent qw(Log::Log4perl::Config::BaseConfigurator);

=head1 NAME

Log::Log4perl::Config::YAMLConfigurator - parser of L<Log::Log4perl>
configuration files based on YAML (L<http://www.yaml.org/spec/>) syntax.

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use Log::Log4perl::Config::YAMLConfigurator;

    my $config = Log::Log4perl::Config::YAMLConfigurator->new();

	$config->file('log4perl.yaml');
	$config->parse();

=head1 DESCRIPTION

=head1 METHODS

=head2 new(I<%args>)

=cut

# Override buggy Log::Log4perl::Config::BaseConfigurator::new() method.
sub new
{
    my ($class, %options) = @_;

    my $self = bless(\%options, $class);

    $self->file($self->{'file'}) if exists($self->{'file'});
    $self->text($self->{'text'}) if exists($self->{'text'});

    return $self;
}

=head2 file

=head2 text

=cut

# This two methods (file and text) inherited from parent
# Log::Log4perl::Config::BaseConfigurator module.

=head2 parse

=cut

sub parse
{
}

=head1 AUTHOR

Denis Ibaev <dionys@cpan.org>

=head1 BUGS

Please report any bugs or feature requests to mailing list at
<bug-log-log4perl-config-yamlconfigurator@rt.cpan.org>, or through the web
interface at L<http://rt.cpan.org/NoAuth/Bugs.html?Queue=Log-Log4perl-Config-YAMLConfigurator>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

The latest development version is available from the Git repository at
L<http://github.com/dionys/log-log4perl-config-yamlconfigurator>

=head1 SUPPORT

You can find documentation for this module with the perldoc command:

    perldoc Log::Log4perl::Config::YAMLConfigurator

You can also look for information at:

=over 4

=item * GitHub

L<http://github.com/dionys/log-log4perl-config-yamlconfigurator>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Log-Log4perl-Config-YAMLConfigurator>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Log-Log4perl-Config-YAMLConfigurator>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Log-Log4perl-Config-YAMLConfigurator>

=item * Search CPAN

L<http://search.cpan.org/dist/Log-Log4perl-Config-YAMLConfigurator/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009 Denis Ibaev.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;
