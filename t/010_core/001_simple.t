use strict;
use warnings;
use Test::More tests => 7;
use FormValidator::Lite;
use CGI;

my $q = CGI->new(
    {
        foo => 'bar',
    },
);
my $v = FormValidator::Lite->new($q);
ok(!$v->has_error);
is($v->query, $q);
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

