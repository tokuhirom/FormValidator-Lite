use strict;
use warnings;
use FormValidator::Lite::ParameterExtraction;
use Test::More tests => 3;
use Test::Requires qw(
    Dancer::Request
    HTTP::Request::Common
    HTTP::Message::PSGI
);

{
    my $req = POST 'http://hoge/',
        Content => {
        foo => 'foooo',
        bar => [ 'b', 'a', 'r' ],
        };
    my $q = Dancer::Request->new(env => $req->to_psgi);
    my $cb = FormValidator::Lite::ParameterExtraction::determine_callback($q);

    is_deeply [$cb->($q, 'foo')], ['foooo'];
    is_deeply [$cb->($q, 'bar')], [qw( b a r )];
    is_deeply [$cb->($q, 'hoge')], [undef];
}
