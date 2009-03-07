use strict;
use warnings;
use Test::More tests => 4;
use FormValidator::Lite;
use CGI;

my $q = CGI->new(
    {
        foo => '1',
    },
);
my $v = FormValidator::Lite->new($q);
ok(!$v->has_error);
$v->check(
    'foo' => [qw/NOT_NULL INT/],
    'baz' => [qw/INT/],
);
ok(!$v->has_error, 'has error');
ok(!$v->is_error('foo'), 'foo');
ok(!$v->is_error('baz'), 'baz');

