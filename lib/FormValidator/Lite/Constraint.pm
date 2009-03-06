package FormValidator::Lite::Constraint;
use strict;
use warnings;

sub import {
    strict->import;
    warnings->import;

    no strict 'refs';
    my $pkg = caller(0);
    *{"$pkg\::rule"}    = \&rule;
    *{"$pkg\::alias"}   = \&alias;
    *{"$pkg\::delsp"}    = \&delsp;
}

sub rule {
    my ($name, $code) = @_;
    $FormValidator::Lite::Rules->{$name} = $code;
}
sub alias {
    my ($from, $to) = @_;
    $FormValidator::Lite::Rules->{$to} = $FormValidator::Lite::Rules->{$from};
}
sub delsp {
    my $x = $_;
    $x =~ s/\s//g;
    return $x;
}

1;
