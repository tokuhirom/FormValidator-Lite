use strict;
use warnings;
use utf8;
use Test::Base::Less;
use FormValidator::Lite;
use CGI;

filters {
    query    => [qw/eval/],
    rule     => [qw/eval/],
    expected => [qw/eval/],
};

for my $block (blocks) {
    my $q = CGI->new($block->query);

    my $v = FormValidator::Lite->new($q);
    $v->check(
        $block->rule
    );

    my @expected = $block->expected;
    while (my ($key, $val) = splice(@expected, 0, 2)) {
        is($v->is_error($key), $val, $block->name);
    }
}

done_testing;

__END__

=== NOT_NULL
--- query: { hoge => 1, zero => 0, blank => "", undef => undef }
--- rule
(
    hoge    => [qw/NOT_NULL/],
    zero    => [qw/NOT_NULL/],
    blank   => [qw/NOT_NULL/],
    undef   => [qw/NOT_NULL/],
    missing => [qw/NOT_NULL/],
);
--- expected
(
    hoge    => 0,
    zero    => 0,
    blank   => 1,
    undef   => 1,
    missing => 1,
)

=== NOT_BLANK
--- query: { hoge => 1, zero => 0, blank => "", undef => undef }
--- rule
(
    hoge    => [qw/NOT_BLANK/],
    zero    => [qw/NOT_BLANK/],
    blank   => [qw/NOT_BLANK/],
    undef   => [qw/NOT_BLANK/],
    missing => [qw/NOT_BLANK/],
);
--- expected
(
    hoge    => 0,
    zero    => 0,
    blank   => 1,
    undef   => 1,
    missing => 1,
)

=== REQUIRED
--- query: { hoge => 1, zero => 0, blank => "", undef => undef }
--- rule
(
    hoge    => [qw/REQUIRED/],
    zero    => [qw/REQUIRED/],
    blank   => [qw/REQUIRED/],
    undef   => [qw/REQUIRED/],
    missing => [qw/REQUIRED/],
);
--- expected
(
    hoge    => 0,
    zero    => 0,
    blank   => 1,
    undef   => 1,
    missing => 1,
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

=== EQUAL
--- query: { 'z1' => 'foo', 'z2' => 'foo' }
--- rule
(
    'z1' => [[EQUAL => 'foo']],
    'z2' => [[EQUAL => 'bar']],
)
--- expected
(
    z1 => 0,
    z2 => 1,
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

=== CHOICE
--- query: { 'z1' => 'foo', 'z2' => 'quux' }
--- rule
(
    z1 => [ ['CHOICE' => [qw/foo bar baz/]] ],
    z2 => [ ['IN'     => [qw/foo bar baz/]] ],
)
--- expected
(
    z1 => 0,
    z2 => 1,
)

=== NOT_IN
--- query: { 'z1' => 'foo', 'z2' => 'quux', z3 => 'hoge', z4 => 'eee' }
--- rule
(
    z1 => [ ['NOT_IN', [qw/foo bar baz/]] ],
    z2 => [ ['NOT_IN', [qw/foo bar baz/]] ],
    z3 => [ ['NOT_IN', []] ],
    z4 => [ ['NOT_IN'] ],
)
--- expected
(
    z1 => 1,
    z2 => 0,
    z3 => 0,
    z4 => 0,
)

=== MATCH
--- query: { 'z1' => 'ba3', 'z2' => 'bao' }
--- rule
(
    z1 => [[MATCH => sub { $_[0] eq 'ba3' } ]],
)
--- expected
(
    z1 => 0,
)

=== FILTER
--- query: { 'foo' => ' 123 ', bar => 'one' }
--- rule
(
    foo => [[FILTER => 'trim'], 'INT'],
    bar => [[FILTER => sub { my $v = shift; $v =~ s/one/1/; $v } ], 'INT'],
)
--- expected
(
    foo => 0,
    bar => 0,
)

=== FILTER (with multiple values)
--- query: { 'foo' => [' 0 ', ' 123 ', ' 234 '], 'bar' => [qw(one one)] }
--- rule
(
    foo => [[FILTER => 'trim'], 'INT'],
    bar => [[FILTER => sub { my $v = shift; $v =~ s/one/1/; $v } ], 'INT'],
)
--- expected
(
    foo => 0,
    bar => 0,
)

=== FLAG
--- query: { z1 => 0, z2 => 1, z3 => 2, z4 => 'foo' }
--- rule
(
    z1 => [qw/FLAG/],
    z2 => [qw/FLAG/],
    z3 => [qw/FLAG/],
    z4 => [qw/FLAG/],
)
--- expected
(
    z1 => 0,
    z2 => 0,
    z3 => 1,
    z4 => 1,
)
