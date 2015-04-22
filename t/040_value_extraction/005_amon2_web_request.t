use strict;
use warnings;
use FormValidator::Lite::ValueExtraction;
use Test::More tests => 2;
use Test::Requires qw(
    Amon2
    Amon2::Web::Request
    HTTP::Request::Common
    HTTP::Message::PSGI
);

{
    package MyApp::Web;
    use parent -norequire, qw(MyApp);
    use parent qw(Amon2::Web);
    sub encoding { 'utf-8' }
}

{
    package MyApp;
    use parent qw(Amon2);
}

{
    my $c = MyApp::Web->bootstrap;
    my $req = POST 'http://hoge/?hoge=ho&hoge=ge',
        Content => {
        foo => 'foooo',
        bar => [ 'b', 'a', 'r' ],
        };
    my $q = Amon2::Web::Request->new($req->to_psgi, $c);
    my $cb = FormValidator::Lite::ValueExtraction::determine_callback($q);

    is_deeply [$cb->($q, 'foo')], ['foooo'];
    is_deeply [$cb->($q, 'bar')], [qw( b a r )];
}
