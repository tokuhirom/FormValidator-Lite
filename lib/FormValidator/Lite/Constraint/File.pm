package FormValidator::Lite::Constraint::File;
use strict;
use warnings;
use FormValidator::Lite::Constraint;
use Carp ();

file_rule 'FILE_MIME' => sub {
    Carp::croak('missing args. usage: ["FILE_MIME", "text/plain"]') unless @_;
    my $expected = $_[0];
    return $_->type =~ /^$expected$/;
};

file_rule 'FILE_SIZE' => sub {
    Carp::croak('missing args. usage: ["FILE_SIZE", 1_000_000, 100]') unless @_;

    my $size   = $_->size;
    my $max    = shift;
    my $min    = shift;

    return 0 if $max < $size;
    return 0 if defined($min) && $min > $size;
    return 1;
};

1;
__END__

=head1 NAME

FormValidator::Lite::Constraint::File - file constraints

=head1 DESCRIPTION

This module provides validation rule for uploaded files.

=head1 RULES

=over 4

=item FILE_MIME

    $valiator->check(
        'file' => [['FILE_MIME', 'text/plain']],
    );

Check the file content-type.

=item FILE_SIZE

    $valiator->check(
        'file' => [['FILE_SIZE', 1_000_000, 100]],
    );

Check the file size. First argument is the upper limit in bytes, and second is lower limit in bytes.
Second argument is optional.

=back


