use strict;
use warnings;
use Test::More;
use Test::Exception;
use Test::Requires {
    'HTML::Shakan'   => 0.09,
    'HTTP::Request'  => 0,
    'Plack::Request' => 0,
    'Plack::Test'    => 0,
    'CGI'            => 0,
};

note "HTML::Shakan $HTML::Shakan::VERSION";
sub form {
    my $request = shift;
    return HTML::Shakan->new(
        fields => [
            FileField(
                name        => 'foo',
                constraints => [ [ 'FILE_MIME', qr{application/.+} ] ]
            ),
        ],
        request => $request
    );
}

subtest 'Plack::Request' => sub {
    note "Plack::Request $Plack::Request::VERSION";
    my $app = sub {
        my $env = shift;
        lives_ok { form( Plack::Request->new($env) ) };
        [ 200, [ 'Content-Type' => 'text/plain' ], ['OK'] ];
    };
    test_psgi $app, sub {
        my $cb = shift;
        $cb->( HTTP::Request->new( 'GET', '/' ) );
    };
};

subtest 'CGI' => sub {
    note "CGI $CGI::VERSION";
    lives_ok { form( CGI->new ) };
};

done_testing;
