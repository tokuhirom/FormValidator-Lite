package FormValidator::Lite::Constraint::Default;
use strict;
use warnings;
use FormValidator::Lite::Constraint;

rule 'NOT_NULL' => sub {
    return 0 if not defined($_);
    return 0 if $_ eq "";
    return 0 if ref($_)eq'ARRAY' && @$_ == 0;
    return 1;
};
rule 'INT'  => sub { $_ =~ /\A[+\-]?[0-9]+\z/ };
rule 'UINT' => sub { $_ =~ /\A[0-9]+\z/      };
alias 'NOT_NULL' => 'NOT_BLANK';
alias 'NOT_NULL' => 'REQUIRED';

rule 'ASCII' => sub {
    $_ =~ /^[\x21-\x7E]+$/
};

# {mails => [qw/mail1 mail2/]} => ['DUPLICATION']
rule 'DUPLICATION' => sub {
    defined($_->[0]) && defined($_->[1]) && $_->[0] eq $_->[1]
};
alias 'DUPLICATION' => 'DUP';

# 'name' => [qw/LENGTH 5 20/],
rule 'LENGTH' => sub {
    my $length = length($_);
    my $min    = shift;
    my $max    = shift || $min;
    Carp::croak("missing \$min") unless defined($min);

    ( $min <= $length and $length <= $max )
};

rule 'EQUAL' => sub {
    Carp::croak("missing \$argument") if @_ == 0;
    $_ eq $_[0]
};

rule 'REGEX' => sub {
    my $regex = shift;
    Carp::croak("missing args at REGEX rule") unless defined $regex;
    $_ =~ /$regex/
};
alias 'REGEX' => 'REGEXP';

rule 'CHOICE' => sub {
    Carp::croak("missing \$choices") if @_ == 0;

    my @choices = @_==1 && ref$_[0]eq'ARRAY' ? @{$_[0]} : @_;

    for my $c (@choices) {
        if ($c eq $_) {
            return 1;
        }
    }
    return 0;
};
alias 'CHOICE' => 'IN';

rule 'NOT_IN' => sub {
    my @choices = @_==1 && ref$_[0]eq'ARRAY' ? @{$_[0]} : @_;

    for my $c (@choices) {
        if ($c eq $_) {
            return 0;
        }
    }
    return 1;
};

rule 'MATCH' => sub {
    my $callback = shift;
    Carp::croak("missing \$callback") if ref $callback ne 'CODE';

    $callback->($_);
};

our $Filters = {
    trim => sub {
        my $value = shift;
        return $value unless $value;
        $value =~ s/^\s+|\s+$//g;
        $value;
    },
};

rule 'FILTER' => sub {
    my $filter = shift;
    Carp::croak("missing \$filter") unless $filter;
    
    if (not ref $filter) {
        $filter = $Filters->{$filter}
            or Carp::croak("$filter is not defined.");
    }
    
    Carp::croak("\$filter must be coderef.") if ref $filter ne 'CODE';
    
    $_ = $filter->($_);
    
    1; # always return true
};

1;
__END__

=head1 NAME

FormValidator::Lite::Constraint::Default - default constraint rules

=head1 DESCRIPTION

This module provides default constraint rules for L<FormValidator::Lite>.

=head1 CONSTRAINTS

=over 4

=item NOT_NULL

The parameter is true value or not.

=item NOT_BLANK, REQUIRED

Synonym of NOT_NULL.

=item INT

The parameter looks like a integer? i.e. It matches /^[+\-]?[0-9]+$/?

=item UINT

The parameter looks like a unsigned integer? i.e. It matches /^[0-9]+$/?

=item ASCII

    $_ =~ /^[\x21-\x7E]+$/

The parameter is just ASCII?

=item DUPLICATION

    $validator->check(
        {mails => [qw/mail1 mail2/]} => ['DUPLICATION']
    );

The two parameters have same value?

=item DUP

Synonym of DUPLICATION.

=item LENGTH
    
    $validator->check(
        name     => [[qw/LENGTH 5 20/]],
        password => [[qw/LENGTH 5/]],
    );

Check the length of data. First argument means $minumum value, second argument is $max.
$max is optional.

=item EQUAL

    $validator->check(
        name => [[EQUAL => "foo"]],
    );

Check parameter match the argument or not.

=item REGEX

    $validator->check(
        name => [[REGEXP => qr/^[0-9]$/]],
    );

Check regexp matches parameter or not.

=item REGEXP

Synonym of REGEX.

=item CHOICE

    $validator->check(
        sex => [[CHOICE => qw/male female/]]
    );

The parameter is one of choice or not.

=item IN

Synonym of CHOICE.

=item NOT_IN

    $validator->check(
        new_user => [[NOT_IN => \@existing_users]]
    );

The parameter does not belong to the list of values.

=item MATCH

    use MyApp::Util qw/is_foo/;

    $validator->check(
        foo => [[MATCH => \&is_foo ]],
        bar => [[MATCH => sub { $_[0] eq 'foo' } ]],
    );

Check parameter using callback. Callback takes parameter as first argument,
should return true/false.

=item FILTER

    $validator->check(
        foo => [[FILTER => 'trim'], 'INT'],
        bar => [[FILTER => sub { $_[0] . '@example.com' } ], 'EMAIL'],
    );

FILTER is special constraint. It does not check the value and simply filter.
"trim" is only pre-defined. You can also pass a callback.
Callback takes parameter as first argument, should return filtered value.

=back

