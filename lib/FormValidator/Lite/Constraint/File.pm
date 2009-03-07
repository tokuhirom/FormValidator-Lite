package FormValidator::Lite::Constraint::File;
use FormValidator::Lite::Constraint;
use Carp ();

file_rule 'FILE_MIME' => sub {
    Carp::croak('missing args. usage: ["FILE_MIME", "text/plain"]') unless @_;
    my $expected = $_[0];
    return $_->type =~ /^$expected$/;
};

1;
