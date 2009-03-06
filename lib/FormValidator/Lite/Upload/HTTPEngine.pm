package FormValidator::Lite::Upload::HTTPEngine;
use strict;
use warnings;
use base qw/FormValidator::Lite::Upload/;

sub new {
    my ($class, $q, $name) = @_;
    my $upload = $q->upload($name);
    return unless $upload;

    bless {
        q        => $q,
        name     => $name,
        upload   => $upload,
    }, $class;
}

sub size { shift->{upload}->size }
sub type { shift->{upload}->type }

sub fh {
    my ($self, ) = @_;
    $self->{upload}->fh;
}

1;
