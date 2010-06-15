use strict;
use warnings;
use Test::More tests => 6;
use FormValidator::Lite;
use CGI;

{
    my $q = CGI->new(
        {
            foo => '0',
        },
    );
    my $v = FormValidator::Lite->new($q);
    ok(!$v->has_error);
    $v->check(
        'foo' => [['REGEX' => qr/\d/]],
        'baz' => [qw/INT/],
    );
    ok(!$v->has_error, 'has error');
    ok(!$v->is_error('foo'), 'foo');
    ok(!$v->is_error('baz'), 'baz');
}

{
    my $q = CGI->new(
        {
            foo => '0',
        },
    );
    my $v = FormValidator::Lite->new($q);
    $v->check(
        'foo'=> [['REGEX' => qr/a/]],
    );
    ok($v->has_error, 'has error');
    ok($v->is_error('foo'), 'foo');
}

