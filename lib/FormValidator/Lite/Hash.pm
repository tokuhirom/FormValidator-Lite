package FormValidator::Lite::Hash;
use strict;
use warnings;
use utf8;
use Carp ();

sub new {
    my $class = shift;
    my %args = @_==1 ? %{$_[0]} : @_;
    bless {%args}, $class;
}

sub param {
    my $self = shift;
    if (@_==1) {
        return $self->{$_[0]};
    } elsif (@_==2) {
        return $self->{$_[0]} = $_[1];
    } elsif (@_==0) {
        return keys %$self;
    } else {
        Carp::croak("Too much arguments for FormValidator::Lite::Hash#param: " . 0+@_);
    }
}

sub upload { undef }

1;
