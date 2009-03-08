package FormValidator::Lite::Constraint::Default;
use FormValidator::Lite::Constraint;

rule 'NOT_NULL' => sub { defined($_) && $_ ne ""     };
rule 'INT'  => sub { $_ =~ /^[+\-]?[0-9]+$/ };
rule 'UINT' => sub { $_ =~ /^[0-9]+$/      };
alias 'NOT_NULL' => 'NOT_BLANK';

rule 'ASCII' => sub {
    $_ =~ /^[\x21-\x7E]+$/
};

# {mails => [qw/mail1 mail2/]} => ['DUPLICATION']
rule 'DUPLICATION' => sub {
    $_->[0] eq $_->[1]
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
