package FormValidator::Lite::Constraint::URL;
use strict;
use warnings;
use FormValidator::Lite::Constraint;

# this regexp is taken from http://www.din.or.jp/~ohzaki/perl.htm#httpURL
# thanks to ohzaki++
rule 'HTTP_URL' => sub {
    $_ =~ /^s?https?:\/\/[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+$/
};

1;
__END__

=head1 NAME

FormValidator::Lite::Constraint::URL - is this valid URL?

=head1 DESCRIPTION

This module provides some URL related constraints for L<FormValidator::Lite>.

=head1 CONSTRAINTS

=over 4

=item HTTP_URL

The parameter is valid URL or not.

=back


