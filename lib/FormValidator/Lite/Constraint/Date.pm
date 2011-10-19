package FormValidator::Lite::Constraint::Date;
use strict;
use warnings;
use FormValidator::Lite::Constraint;

rule 'DATE' => sub {
    if (ref $_) {
        # query: y=2009&m=09&d=02
        # rule:  {date => [qw/y m d/]} => ['DATE']
        return 0 unless scalar(@{$_}) == 3;
        _v(@{$_});
    } else {
        # query: date=2009-09-02
        # rule:  date => ['DATE']
        _v(split /-/, $_);
    }
};

sub _v {
    my ($y, $m, $d) = @_;

    return 0 if ( !$y or !$m or !$d );

    if ($d > 31 or $d < 1 or $m > 12 or $m < 1 or $y == 0) {
        return 0;
    }
    if ($d > 30 and ($m == 4 or $m == 6 or $m == 9 or $m == 11)) {
        return 0;
    }
    if ($d > 29 and $m == 2) {
        return 0;
    }
    if ($m == 2 and $d > 28 and !($y % 4 == 0 and ($y % 100 != 0 or $y % 400 == 0))){
        return 0;
    }
    return 1;
}


1;
__END__

=head1 NAME

FormValidator::Lite::Constraint::Date - date constraints

=head1 DESCRIPTION

This module provides date constraints.

=head1 CONSTRAINTS

=over 4

=item DATE

    $validator = FormValidator::Lite->new(CGI->new("date=2009-09-02"));
    $validator->check(
        date => ['DATE']
    );
    # or
    $validator = FormValidator::Lite->new(CGI->new("y=2009&m=09&d=02"));
    $validator->check(
        {date => [qw/y m d/]} => ['DATE']
    );

This constraints checks the parameter is valid date or not.

=back

