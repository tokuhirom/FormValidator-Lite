use strict;
use warnings;
use Test::More;
use FormValidator::Lite;
use Test::Requires 'Hash::MultiValue';
use CGI;

subtest 'simple' => sub {
    my $q = Hash::MultiValue->new(
        foo => 'bar',
    );
    my $v = FormValidator::Lite->new($q);
    ok(!$v->has_error);
    isa_ok($v->query, 'FormValidator::Lite::Hash');
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

    is_deeply(
        $v->errors,
        {
            'baz' => {
                'NOT_NULL' => 1
            },
            'boy' => {
                'is_girl' => 1
            },
        },
        'errors()',
    );
};

subtest 'multiple values' => sub {
    my $v = FormValidator::Lite->new(Hash::MultiValue->new(
        foo => ' 0 ',
        foo => ' 123 ',
        foo => ' 234 ',
    ));
    ok(!$v->has_error);
    $v->check(
        foo => [[FILTER => 'trim'], 'INT'],
    );
    ok(!$v->has_error);
};

done_testing;
