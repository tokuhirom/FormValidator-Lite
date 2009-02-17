use strict;
use warnings;
use Test::More tests => 11;
use OreOre::Validator;
use CGI;

my $q = CGI->new(
    {
        foo => 'bar',
    },
);
my $v = OreOre::Validator->new($q);
ok(!$v->has_error);
$v->check(
    'foo' => [qw/NOT_NULL/],
    'baz' => [qw/NOT_NULL/],
    'boo' => [qw/NULL/],
);
ok($v->has_error);
ok(!$v->is_error('foo'));
ok($v->is_error('baz'));
ok(!$v->is_error('boo'));

ok(!$v->is_error('boy'));
$v->set_error('boy' => 'is_girl');
ok($v->is_error('boy'));

# alias
ok(!$v->is_error('hey'));
ok(!$v->is_error('yo'));
$v->set_alias('yo' => 'hey');
$v->set_error('hey' => 'boo');
ok($v->is_error('hey'));
ok($v->is_error('yo'));

