use strict;
use warnings;
package Mixin::Linewise;
{
  $Mixin::Linewise::VERSION = '0.102';
}
# ABSTRACT: write your linewise code for handles; this does the rest
use 5.006;
use Carp ();
Carp::confess "not meant to be loaded";


1;

__END__

=pod

=head1 NAME

Mixin::Linewise - write your linewise code for handles; this does the rest

=head1 VERSION

version 0.102

=head1 DESCRIPTION

It's boring to deal with opening files for IO, converting strings to
handle-like objects, and all that.  With L<Mixin::Linewise::Readers> and
L<Mixin::Linewise::Writers>, you can just write a method to handle handles, and
methods for handling strings and filenames are added for you.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
