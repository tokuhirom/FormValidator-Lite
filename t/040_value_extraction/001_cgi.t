use strict;
use warnings;
use FormValidator::Lite::ValueExtraction;
use Test::More tests => 3;
use CGI;

{
    my $q = CGI->new(
        {
            foo => 'foooo',
            bar => ['b', 'a', 'r'],
        },
    );
    my $cb = FormValidator::Lite::ValueExtraction::determine_callback($q);

    is_deeply [$cb->($q, 'foo')], ['foooo'];
    is_deeply [$cb->($q, 'bar')], [qw( b a r )];
    is_deeply [$cb->($q, 'hoge')], [undef];
}
