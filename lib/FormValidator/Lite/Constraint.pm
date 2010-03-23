package FormValidator::Lite::Constraint;
use strict;
use warnings;

sub import {
    strict->import;
    warnings->import;

    no strict 'refs';
    my $pkg = caller(0);
    *{"$pkg\::rule"}    = \&rule;
    *{"$pkg\::file_rule"}    = \&file_rule;
    *{"$pkg\::alias"}   = \&alias;
    *{"$pkg\::delsp"}    = \&delsp;
}

sub rule {
    my ($name, $code) = @_;
    $FormValidator::Lite::Rules->{$name} = $code;
}
sub file_rule {
    my ($name, $code) = @_;
    $FormValidator::Lite::FileRules->{$name} = $code;
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
__END__

=head1 NAME

FormValidator::Lite::Constraint - utilities for writing constraint rules.

=head1 DESCRIPTION

This module provides some utility classes for writing constraint rules declaratively.

This module enables strict->import and warnings->import automatically.

=head1 FUNCTIONS

=over 4

=item rule($name, $code)

Define new rule.

=item file_rule($name, $code)

Define new file uploading rule.

=item alias($from => $to)

Define the alias.

=item delsp($x)

Remove white space from $x and return it.

=back


