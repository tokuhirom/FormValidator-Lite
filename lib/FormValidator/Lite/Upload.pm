package FormValidator::Lite::Upload;
use strict;
use warnings;
use Carp ();
use Scalar::Util qw/blessed/;

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
    Carp::croak("\$q is not a object") unless blessed $q;

    my $pkg = do {
        if ($q->isa('CGI')) {
            'CGI';
        } elsif ($q->isa('HTTP::Engine::Request')) {
            'HTTPEngine';
        } else {
            if ($q->can('upload') && (my $u = $q->upload($name))) {
                # this feature is needed by HTML::Shakan or other form validation libraries
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
