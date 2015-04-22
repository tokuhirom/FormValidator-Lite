use strict;
use warnings;
use FormValidator::Lite::Hash;
use FormValidator::Lite::ValueExtraction;
use Hash::MultiValue;
use Test::More tests => 3;

{
    my $q = FormValidator::Lite::Hash->new(
        Hash::MultiValue->new(
            foo => 'foooo',
            bar => 'b',
            bar => 'a',
            bar => 'r',
        )->flatten,
    );
    my $cb = FormValidator::Lite::ValueExtraction::determine_callback($q);

    is_deeply [$cb->($q, 'foo')], ['foooo'];
    is_deeply [$cb->($q, 'bar')], [qw( b a r )];
    is_deeply [$cb->($q, 'hoge')], [undef];
}
