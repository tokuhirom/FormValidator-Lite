use strict;
use warnings;
use utf8;
use Test::Base;
use FormValidator::Lite;
use CGI;

plan tests => 24;

filters {
    query    => [qw/eval/],
    rule     => [qw/eval/],
    expected => [qw/eval/],
};

run {
    my $block = shift;
    my $q = CGI->new($block->query);

    my $v = FormValidator::Lite->new($q);
    $v->check(
        $block->rule
    );

    my @expected = $block->expected;
    while (my ($key, $val) = splice(@expected, 0, 2)) {
        is($v->is_error($key), $val, $block->name);
    }
};


__END__

=== NOT_NULL
--- query: { hoge => 1, hoga => "" }
--- rule
(
    hoge => [qw/NOT_NULL/],
    hoga => [qw/NOT_NULL/],
    fuga => [qw/NOT_NULL/],
);
--- expected
(
    hoge => 0,
    hoga => 1,
    fuga => 1,
)

=== INT
--- query: { hoge => '1', fuga => '-1', hoga => 'ascii', foo => "1\n" }
--- rule
(
    hoge => [qw/INT/],
    fuga => [qw/INT/],
    hoga => [qw/INT/],
    foo  => [qw/INT/],
)
--- expected
(
    hoge => 0,
    fuga => 0,
    hoga => 1,
    foo  => 1,
)

=== UINT
--- query: { hoge => '1', fuga => '-1', hoga => 'ascii', foo => "1\n" }
--- rule
(
    hoge => [qw/UINT/],
    fuga => [qw/UINT/],
    hoga => [qw/UINT/],
    foo  => [qw/UINT/],
)
--- expected
(
    hoge => 0,
    fuga => 1,
    hoga => 1,
    foo  => 1,
)

=== ASCII
--- query: { hoge => 'abcdefg', fuga => 'あbcdefg' }
--- rule
(
    hoge => [qw/ASCII/],
    fuga => [qw/ASCII/],
)
--- expected
(
    hoge => 0,
    fuga => 1,
)

=== DUPLICATION
--- query: { 'z1' => 'foo', 'z2' => 'foo', 'z3' => 'fob' }
--- rule
(
    {x1 => [qw/z1 z2/]} => ['DUPLICATION'],
    {x2 => [qw/z2 z3/]} => ['DUPLICATION'],
    {x3 => [qw/z1 z3/]} => ['DUPLICATION'],
)
--- expected
(
    x1 => 0,
    x2 => 1,
    x3 => 1,
)

=== LENGTH
--- query: { 'z1' => 'foo', 'z2' => 'foo', 'z3' => 'foo', 'x1' => 'foo', x2 => 'foo', x3 => 'foo' }
--- rule
(
    z1 => [['LENGTH', '2']],
    z2 => [['LENGTH', '3']],
    z3 => [['LENGTH', '4']],
    x1 => [['LENGTH', '2', '2']],
    x2 => [['LENGTH', '2', '3']],
    x3 => [['LENGTH', '2', '4']],
)
--- expected
(
    z1 => 1,
    z2 => 0,
    z3 => 1,
    x1 => 1,
    x2 => 0,
    x3 => 0,
)

=== REGEX
--- query: { 'z1' => 'ba3', 'z2' => 'bao' }
--- rule
(
    z1 => [['REGEX',  '^ba[0-9]$']],
    z2 => [['REGEXP', '^ba[0-9]$']],
)
--- expected
(
    z1 => 0,
    z2 => 1,
)

