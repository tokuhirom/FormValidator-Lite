package FormValidator::Lite::Upload::CGI;
use strict;
use warnings;
use base qw/FormValidator::Lite::Upload/;

sub new {
    my ($class, $q, $name) = @_;
    my $file = $q->param($name);
    return unless $file;

    my $info = $q->uploadInfo($file);
    bless {
        q        => $q,
        name     => $name,
        info     => $info,
    }, $class;
}

sub size { shift->{info}->{'Content-Length'} }
sub type { shift->{info}->{'Content-Type'}   }

sub fh {
    my ($self, ) = @_;
    $self->{q}->upload($self->{name});
}

1;
