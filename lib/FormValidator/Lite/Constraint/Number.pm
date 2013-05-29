package FormValidator::Lite::Constraint::Number;
use strict;
use warnings;
use FormValidator::Lite::Constraint;

rule BETWEEN => sub {
    $_[0] <= $_ && $_ <= $_[1];
};

rule LESS_THAN => sub {
    $_ < $_[0];
};

rule LESS_EQUAL => sub {
    $_ <= $_[0];
};

rule MORE_THAN => sub {
    $_[0] < $_;
};

rule MORE_EQUAL => sub {
    $_[0] <= $_;
};

1;
__END__

=head1 NAME

FormValidator::Lite::Constraint::Number - number constraints

=head1 DESCRIPTIOIN

This module provides number comparison constraints.

=head1 CONSTRAINTS

=over 4

=item BETWEEN

    $v->check(
        number => [BETWEEN => qw/1 10/],
    );

Checks if parameter is between given interval.

=item LESS_THAN

Checks if parameter is B<less than> given limit.

=item LESS_EQUAL

Checks if parameter is B<less than or equal to> given limit.

=item MORE_THAN

Checks if parameter is B<more than> given limit.

=item MORE_EQUAL

Checks if parameter is B<more than or equal to> given limit.

=back
