package FormValidator::Lite::Upload::PlackRequest;
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
    my $fname = $self->{upload}->path;
    open my $fh, '<', $fname or die "cannot open temporary file: $fname: $!";
    return $fh;
}

1;

