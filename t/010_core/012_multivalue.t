use strict;
use warnings;
use Test::More tests => 13;
use FormValidator::Lite;
use CGI;

{
    # Optional parameter foo has multiple empty string values
    my $q = CGI->new(
        {
            foo => ['', ''],
        },
    );
    my $v = FormValidator::Lite->new($q);
    ok(!$v->has_error);
    is($v->query, $q);
    $v->check(
        'foo' => [
            [CHOICE => qw/hoge fuga/],
        ],
    );
    ok(!$v->has_error);
};
{
    # Optional parameter foo has multiple zeros and check against ''
    my $q = CGI->new(
        {
            foo => [qw/0 0/],
        },
    );
    my $v = FormValidator::Lite->new($q);
    ok(!$v->has_error);
    $v->check(
        'foo' => [
            [CHOICE => '']
        ],
    );
    ok($v->has_error);
    is_deeply($v->errors, {
        foo => {
            CHOICE => 2,
        }
    });
};
{
    # Detect required param foo is not null,
    # first and second items are valid,
    # and third item is invalid
    my $q = CGI->new(
        {
            foo => [qw(0 1 3)],
        },
    );
    my $v = FormValidator::Lite->new($q);
    ok(!$v->has_error);
    is($v->query, $q);
    $v->check(
        'foo' => [
            'NOT_NULL',
            [CHOICE => qw/0 1 2/],
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
    # Detect all items in foo are valid
    my $q = CGI->new(
        {
            foo => [qw(0 1 3)],
        },
    );
    my $v = FormValidator::Lite->new($q);
    $v->check(
        foo => [
            'NOT_NULL',
            [CHOICE => qw/0 1 2 3/],
        ],
    );
    ok(!$v->has_error);
    is_deeply($v->errors, { });
};
