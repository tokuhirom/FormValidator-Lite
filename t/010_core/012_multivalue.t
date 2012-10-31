use strict;
use warnings;
use Test::More tests => 12;
use FormValidator::Lite;
use CGI;

{
    my $q = CGI->new(
        {
            foo => ['bar', 'hoge'],
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
};
{
    my $q = CGI->new(
        {
            foo => [qw(3 1)],
        },
    );
    my $v = FormValidator::Lite->new($q);
    ok(!$v->has_error);
    is($v->query, $q);
    $v->check(
        'foo' => [
            'NOT_NULL',
            [CHOICE => qw/1 2/],
        ],
    );
    ok($v->has_error);
    ok($v->is_error('foo'));
    is_deeply($v->errors, {
        foo => {
            CHOICE => 1
        },
    });
};
{
    my $q = CGI->new(
        {
            foo => [qw(3 1)],
        },
    );
    my $v = FormValidator::Lite->new($q);
    $v->check(
        foo => [
            'NOT_NULL',
            [CHOICE => qw/1 2 3/],
        ],
    );
    ok(!$v->has_error);
    is_deeply($v->errors, { });
};
