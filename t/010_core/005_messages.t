use strict;
use warnings;
use Test::More tests => 4;
use FormValidator::Lite;
use CGI;

my $q = CGI->new(
    {
        foo => 'bar',
    },
);
my $v = FormValidator::Lite->new($q);
ok(!$v->has_error);
$v->check(
    'foo' => [qw/NOT_NULL/],
    'baz' => [qw/NOT_NULL/],
);
ok($v->has_error);
$v->load_function_message('en');
$v->set_param_message(
    bar => 'bar',
    baz => 'baz',
);
is join('', $v->get_error_messages), 'please input baz';

$v->set_message('baz.not_null' => 'pleeeeeease input baz');
is join('', $v->get_error_messages), 'pleeeeeease input baz';

