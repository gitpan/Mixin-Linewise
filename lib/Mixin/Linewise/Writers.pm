use strict;
use warnings;
package Mixin::Linewise::Writers;
# ABSTRACT: get linewise writers for strings and filenames
$Mixin::Linewise::Writers::VERSION = '0.105';
use 5.8.1; # PerlIO
use Carp ();
use IO::File;

use Sub::Exporter -setup => {
  exports => { map {; "write_$_" => \"_mk_write_$_" } qw(file string) },
  groups  => {
    default => [ qw(write_file write_string) ],
    writers => [ qw(write_file write_string) ],
  },
};

# =head1 SYNOPSIS
#
#   package Your::Pkg;
#   use Mixin::Linewise::Writers -writers;
#
#   sub write_handle {
#     my ($self, $data, $handle) = @_;
#
#     $handle->print("datum: $_\n") for @$data;
#   }
#
# Then:
#
#   use Your::Pkg;
#
#   Your::Pkg->write_file($data, $filename);
#
#   Your::Pkg->write_string($data, $string);
#
#   Your::Pkg->write_handle($data, $fh);
#
# =head1 EXPORTS
#
# C<write_file> and C<write_string> are exported by default.  Either can be
# requested individually, or renamed.  They are generated by
# L<Sub::Exporter|Sub::Exporter>, so consult its documentation for more
# information.
#
# Both can be generated with the option "method" which requests that a method
# other than "write_handle" is called with the created IO::Handle.
#
# If given a "binmode" option, any C<write_file> type functions will use
# that as an IO layer, otherwise, the default is C<encoding(UTF-8)>.
#
#   use Mixin::Linewise::Writers -writers => { binmode => "raw" };
#   use Mixin::Linewise::Writers -writers => { binmode => "encoding(iso-8859-1)" };
#
# =head2 write_file
#
#   Your::Pkg->write_file($data, $filename);
#   Your::Pkg->write_file($data, $options, $filename);
#
# This method will try to open a new file with the given name.  It will then call
# C<write_handle> with that handle.
#
# An optional hash reference may be passed before C<$filename> with options.
# The only valid option currently is C<binmode>, which overrides any
# default set from C<use> or the built-in C<encoding(UTF-8)>.
#
# Any arguments after C<$filename> are passed along after to C<write_handle>.
#
# =cut

sub _mk_write_file {
  my ($self, $name, $arg) = @_;
  my $method = defined $arg->{method} ? $arg->{method} : 'write_handle';
  my $dflt_enc = defined $arg->{binmode} ? $arg->{binmode} : 'encoding(UTF-8)';

  sub {
    my ($invocant, $data, $options, $filename);
    if ( ref $_[2] eq 'HASH' ) {
      # got options before filename
      ($invocant, $data, $options, $filename) = splice @_, 0, 4;
    }
    else {
      ($invocant, $data, $filename) = splice @_, 0, 3;
    }

    $options->{binmode} = $dflt_enc unless defined $options->{binmode};
    $options->{binmode} =~ s/^://; # we add it later

    # Check the file
    Carp::croak "no filename specified"           unless $filename;
    Carp::croak "'$filename' is not a plain file" if -e $filename && ! -f _;

    # Write out the file
    my $handle = IO::File->new($filename, ">:$options->{binmode}")
      or Carp::croak "couldn't write to file '$filename': $!";

    $invocant->write_handle($data, $handle, @_);
  }
}

# =head2 write_string
#
#   my $string = Your::Pkg->write_string($data);
#
# C<write_string> will create a new handle on the given string, then call
# C<write_handle> to write to that handle, and return the resulting string.
# Because handles on strings must be octet-oriented, the string B<must contain
# octets>.  It will be opened in the default binmode established by importing.
# (See L</EXPORTS>, above.)
#
# Any arguments after C<$data> are passed along after to C<write_handle>.
#
# =cut

sub _mk_write_string {
  my ($self, $name, $arg) = @_;
  my $method = defined $arg->{method} ? $arg->{method} : 'write_handle';
  my $dflt_enc = defined $arg->{binmode} ? $arg->{binmode} : 'encoding(UTF-8)';

  sub {
    my ($invocant, $data) = splice @_, 0, 2;

    my $binmode = $dflt_enc;
    $binmode =~ s/^://; # we add it later

    my $string = '';
    open my $handle, ">:$binmode", \$string
      or die "error opening string for output: $!";

    $invocant->write_handle($data, $handle, @_);
    close $handle or die "error closing string after output: $!";

    return $string;
  }
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Mixin::Linewise::Writers - get linewise writers for strings and filenames

=head1 VERSION

version 0.105

=head1 SYNOPSIS

  package Your::Pkg;
  use Mixin::Linewise::Writers -writers;

  sub write_handle {
    my ($self, $data, $handle) = @_;

    $handle->print("datum: $_\n") for @$data;
  }

Then:

  use Your::Pkg;

  Your::Pkg->write_file($data, $filename);

  Your::Pkg->write_string($data, $string);

  Your::Pkg->write_handle($data, $fh);

=head1 EXPORTS

C<write_file> and C<write_string> are exported by default.  Either can be
requested individually, or renamed.  They are generated by
L<Sub::Exporter|Sub::Exporter>, so consult its documentation for more
information.

Both can be generated with the option "method" which requests that a method
other than "write_handle" is called with the created IO::Handle.

If given a "binmode" option, any C<write_file> type functions will use
that as an IO layer, otherwise, the default is C<encoding(UTF-8)>.

  use Mixin::Linewise::Writers -writers => { binmode => "raw" };
  use Mixin::Linewise::Writers -writers => { binmode => "encoding(iso-8859-1)" };

=head2 write_file

  Your::Pkg->write_file($data, $filename);
  Your::Pkg->write_file($data, $options, $filename);

This method will try to open a new file with the given name.  It will then call
C<write_handle> with that handle.

An optional hash reference may be passed before C<$filename> with options.
The only valid option currently is C<binmode>, which overrides any
default set from C<use> or the built-in C<encoding(UTF-8)>.

Any arguments after C<$filename> are passed along after to C<write_handle>.

=head2 write_string

  my $string = Your::Pkg->write_string($data);

C<write_string> will create a new handle on the given string, then call
C<write_handle> to write to that handle, and return the resulting string.
Because handles on strings must be octet-oriented, the string B<must contain
octets>.  It will be opened in the default binmode established by importing.
(See L</EXPORTS>, above.)

Any arguments after C<$data> are passed along after to C<write_handle>.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut