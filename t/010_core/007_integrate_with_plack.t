use strict;
use warnings;
use Test::More tests => 6;
use Test::Requires 'Plack::Request';
use FormValidator::Lite;

my $q = Plack::Request->new(
    {
        QUERY_STRING   => 'foo=bar',
        REQUEST_METHOD => 'POST',
        'psgi.input'   => *STDIN,
    },
);
my $v = FormValidator::Lite->new($q);
ok(!$v->has_error);
$v->check(
    'foo' => [qw/NOT_NULL/],
    'baz' => [qw/NOT_NULL/],
);
ok($v->has_error);
ok(!$v->is_error('foo'));
ok($v->is_error('baz'), 'baz');

ok(!$v->is_error('boy'));
$v->set_error('boy' => 'is_girl');
ok($v->is_error('boy'));

