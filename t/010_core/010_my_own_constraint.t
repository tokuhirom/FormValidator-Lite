use strict;
use warnings;
use Test::More tests => 5;
use FormValidator::Lite;
use CGI;

my $q = CGI->new(
    {
        foo => '00:00',
        bar => 'ppppp',
    },
);
my $v = FormValidator::Lite->new($q);
$v->load_constraints('+FormValidator::Lite::Constraint::Time');
ok(!$v->has_error);
is($v->query, $q);
$v->check(
    'foo' => [qw/TIME NOT_NULL/],
    'bar' => [qw/TIME NOT_NULL/],
);
ok($v->has_error);
ok(!$v->is_error('foo'));
ok($v->is_error('bar'));

