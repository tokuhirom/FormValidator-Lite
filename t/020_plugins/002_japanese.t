use strict;
use warnings;
use utf8;
use Test::Base;
use OreOre::Validator qw/Japanese/;
use CGI;

plan tests => 12;

filters {
    query    => [qw/eval/],
    rule     => [qw/eval/],
    expected => [qw/eval/],
};

run {
    my $block = shift;
    my $q = CGI->new($block->query);

    my $v = OreOre::Validator->new($q);
    $v->check(
        $block->rule
    );

    my @expected = $block->expected;
    while (my ($key, $val) = splice(@expected, 0, 2)) {
        is($v->is_error($key), $val, $block->name);
    }
};


__END__

=== HIRAGANA
--- query: { hoge => 'ひらがなひらがな', fuga => 'カタカナ', haga => 'asciii', hoga => 'ひらがなと  すぺえす'}
--- rule
(
    hoge => [qw/HIRAGANA/],
    fuga => [qw/HIRAGANA/],
    hoga => [qw/HIRAGANA/],
    haga => [qw/HIRAGANA/],
);
--- expected
(
    hoge => 0,
    fuga => 1,
    hoga => 0,
    haga => 1,
)

=== KATAKANA
--- query: { 'p1' => 'ひらがなひらがな', 'p2' => 'カタカナ', 'p3' => 'カタカナ ト スペエス', p4 => 'ascii'}
--- rule
(
    p1 => [qw/KATAKANA/],
    p2 => [qw/KATAKANA/],
    p3 => [qw/KATAKANA/],
    p4 => [qw/KATAKANA/],
);
--- expected
(
    p1 => 1,
    p2 => 0,
    p3 => 0,
    p4 => 1,
)

=== JTEL
--- query: { 'p1' => '666-666-6666', 'p2' => '03-5555-5555'}
--- rule
(
    p1 => [qw/JTEL/],
    p2 => [qw/JTEL/],
);
--- expected
(
    p1 => 1,
    p2 => 0,
)

=== JZIP
--- query: { 'p1' => '155-0044', 'p2' => '03-5555-5555'}
--- rule
(
    p1 => [qw/JZIP/],
    p2 => [qw/JZIP/],
);
--- expected
(
    p1 => 0,
    p2 => 1,
)

