package FormValidator::Lite::Upload;
use strict;
use warnings;
use Carp ();

{
    my %cache;
    sub _load {
        my $pkg = shift;
        unless ($cache{$pkg}++) {
            eval "use $pkg"; ## no critic
            Carp::croak($@) if $@;
        }
        $pkg;
    }
}


sub new {
    my ($self, $q, $name) = @_;
    Carp::croak("missing parameter \$name") unless $name;

    my $pkg = do {
        if (ref $q eq 'CGI') {
            'CGI';
        } elsif (ref $q eq 'HTTP::Engine::Request') {
            'HTTPEngine';
        } else {
            if ($q->can('upload') && (my $u = $q->upload($name))) {
                return $u; # special case :)
            } else {
                die "unknown request type: $q";
            }
        }
    };
    $pkg = 'FormValidator::Lite::Upload::' . $pkg;

    _load($pkg)->new($q, $name);
}

1;
