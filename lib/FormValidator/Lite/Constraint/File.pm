package FormValidator::Lite::Constraint::File;
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
