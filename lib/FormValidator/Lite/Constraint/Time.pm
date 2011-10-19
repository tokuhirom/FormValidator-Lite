package  FormValidator::Lite::Constraint::Time;
use strict;
use warnings;
use FormValidator::Lite::Constraint;

rule 'TIME' => sub {
    if ( ref $_) {
        # query: h=12&m=00&d=60
        # rule:  {time => [qw/h m s/]} => ['TIME']
        _v(@{$_});
    } else {
        # query: time=12:00:30
        # rule:  time => ['time']
        _v(split /:/, $_);
    }
};

sub _v {
    my ($h, $m, $s) = @_;

    return 0 if (!defined($h) or !defined($m));
    return 0 if ("$h" eq "" or "$m" eq "");
    $s ||= 0; # optional

    if ( $h > 23 or $h < 0 or $m > 59 or $m < 0 or $s > 59 or $s < 0 ) {
        return 0;
    }

    return 1;
}

1;
__END__

=head1 NAME

FormValidator::Lite::Constraint::Time - time constraints

=head1 DESCRIPTION

This module provides time constraints.

=head1 CONSTRAINTS

=over 4

=item TIME

    $validator = FormValidator::Lite->new(CGI->new("time=12:29:30"));
    $validator->check(
        time => ['TIME']
    );
    # or
    $validator = FormValidator::Lite->new(CGI->new("h=12&m=29&s=30"));
    $validator->check(
        {time => [qw/h m s/]} => ['TIME']
    );

This constraints checks the parameter is valid time or not.

=back

