package FormValidator::Lite::Constraint::Default;
use FormValidator::Lite::Constraint;

rule 'NOT_NULL' => sub {
    return 0 if not defined($_);
    return 0 if $_ eq "";
    return 0 if ref($_)eq'ARRAY' && @$_ == 0;
    return 1;
};
rule 'INT'  => sub { $_ =~ /^[+\-]?[0-9]+$/ };
rule 'UINT' => sub { $_ =~ /^[0-9]+$/      };
alias 'NOT_NULL' => 'NOT_BLANK';

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

=item NOT_BLANK

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

=back

