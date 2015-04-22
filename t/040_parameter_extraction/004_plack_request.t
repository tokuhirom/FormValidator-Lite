use strict;
use warnings;
use FormValidator::Lite::ParameterExtraction;
use Test::More tests => 3;
use Test::Requires qw(
    HTTP::Request::Common
    HTTP::Message::PSGI
    Plack::Request
);

{
    my $req = POST 'http://hoge/',
        Content => {
        foo => 'foooo',
        bar => [ 'b', 'a', 'r' ],
        };
    my $q = Plack::Request->new($req->to_psgi);
    my $cb = FormValidator::Lite::ParameterExtraction::determine_callback($q);

    is_deeply [$cb->($q, 'foo')], ['foooo'];
    is_deeply [$cb->($q, 'bar')], [qw( b a r )];
    is_deeply [$cb->($q, 'hoge')], [undef];
}
