package Log::Log4perl::Config::YAMLConfigurator;

use warnings;
use strict;

use parent qw(Log::Log4perl::Config::BaseConfigurator);

use Hash::Merge qw(merge);
use Log::Log4perl::Config ();

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

=cut

{
	*_unlog4j = \&Log::Log4perl::Config::unlog4j;
	eval
	{
		require YAML::Syck;
		*_parse = \&YAML::Syck::Load;
	};
	if ($@)
	{
		require YAML;
		*_parse = \&YAML::Load;
	}
}

=head1 METHODS

=head2 C<new()>

This is a constructor for configuration parser. It may takes list of
parameters.

    my $config = Log::Log4perl::Config::YAMLConfigurator->new(
        'text' => [
            'category.Foo::Bar: WARN, Screen',
            'appender.Screen:',
            '    class:    Log::Log4perl::Appender::File',
            '    filename: test.log',
            '    layout:   Log::Log4perl::Layout::SimpleLayout',
        ];
    );

This is a list of support parameters:

=over 4

=item * I<file>

A path to configuration file which the L<C<parse()>|/"parse()"> method later
parses.

=item * I<text>

A reference to an array of scalars, representing configuration records
(typically lines of a file) which the L<C<parse()>|/"parse()"> method later
parses. Also accepts a simple scalar, which it splits at its newlines and
transforms it into an array.

=back

If either file or text parameters have been specified in the constructor call,
a later call to the configurator's L<C<text()>|/"text()"> method will return a
reference to an array of configuration text lines. This will typically be used
by the L<C<parse()>|/"parse()"> method to process the input.

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

=head2 file()

Sets a path to configuration file as C<file> argument of the
L<C<new()>|/"new()"> constructor.

=head2 C<text()>

Sets a configuration text as C<text> argument of the L<C<new()>|/"new()">
constructor.

=cut

# This two methods (file and text) inherited from parent
# Log::Log4perl::Config::BaseConfigurator module.

=head2 C<parse()>

=cut

sub parse
{
    my ($self, $text) = @_;

    $self->text($text) if defined($text);

    die('Config parser has nothing to parse') unless defined($self->{'text'});

    return (_rearrange(undef, (_convert(undef, _parse(join('', @{$self->{'text'}}))))[1]))[1];
}

sub _convert
{
    my ($key, $value, $level) = @_;

    $key   ||= '';
    $level ||= 0;

    if (ref($value) eq 'HASH')
    {
        my %hash;

        foreach (keys(%{$value}))
        {
            my @list = _convert($_, $value->{$_}, $level + 1);

            if (exists($hash{$list[0]}))
            {
                $hash{$list[0]} = merge($hash{$list[0]}, $list[1]);
            }
            else
            {
                $hash{$list[0]} = $list[1];
            }
        }
        $value = \%hash;
    }
    else
    {
        $value = { 'value' => $value, };
    }

    my @path = split(/::|\./, $level ? $key : _unlog4j($key));

    $key   = shift(@path);
    $value = { $_ => $value, } foreach (reverse(@path));

    unless ($level)
    {
        my @keys = keys(%{$value});

        if (scalar(@keys) == 1 && _unlog4j($keys[0] . '.') eq '')
        {
            return ($key, $value->{$keys[0]});
        }
    }

    return ($key, $value);
}

sub _rearrange
{
	my ($key, $value, $level, $root) = @_;

	$key   ||= '';
	$level ||= 0;

	if (!$level && exists($value->{'logger'}))
	{
		if (exists($value->{'category'}))
		{
			$value->{'category'} = merge($value->{'category'}, delete($value->{'logger'}));
		}
		else
		{
			$value->{'category'} = delete($value->{'logger'});
		}
	}

	if (ref($value) eq 'HASH' && !($root && $root eq 'data'))
	{
		my (%hash, $param);

		if ($root)
		{
			if ($key eq 'class' && exists($value->{'value'}) && !ref($value->{'value'}))
			{
				return ('value', $value->{'value'});
			}
			if (exists($value->{'param'}) && ref($value->{'param'}) eq 'HASH')
			{
				$param = delete($value->{'param'});
			}
			if ((exists($value->{'priority'}) || exists($value->{'appender'})) && $root eq 'category')
			{
				return (
					$key,
					{
						'value' => join(
							', ',
							$value->{'priority'}{'value'} || '',
							ref($value->{'appender'}{'value'}) eq 'ARRAY' ?
									@{$value->{'appender'}{'value'}} :
									$value->{'appender'}{'value'} || ''
						),
					}
				);
			}
		}
		foreach (keys(%{$value}))
		{
			my @list = _rearrange($_, $value->{$_}, $level + 1, $level ? $root : $_);

			$hash{$list[0]} = $list[1];
		}
		if ($param)
		{
			$value = merge(\%hash, $param);
		}
		else
		{
			$value = \%hash;
		}
	}

	if (!$level && !exists($value->{'rootLogger'}) &&
			exists($value->{'category'}) &&
			exists($value->{'category'}{'root'}))
	{
		$value->{'rootLogger'} = delete($value->{'category'}{'root'});
	}

	return ($key, $value);
}

=head1 EXAMPLES

=head1 SEE ALSO

L<Log::Log4perl::Config>, L<Log::Log4perl::Config::BaseConfigurator>,
L<Log::Log4perl::Config::PropertyConfigurator>,
L<Log::Log4perl::Config::DOMConfigurator>.

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
