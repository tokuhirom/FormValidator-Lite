use strict;
use warnings;
use FormValidator::Lite::ParameterExtraction;
use Test::More tests => 2;
use CGI;

{
    my $q = CGI->new(
        {
            foo => 'foooo',
            bar => ['b', 'a', 'r'],
        },
    );
    my $cb = FormValidator::Lite::ParameterExtraction::determine_callback($q);

    is_deeply [$cb->($q, 'foo')], ['foooo'];
    is_deeply [$cb->($q, 'bar')], [qw( b a r )];
}
