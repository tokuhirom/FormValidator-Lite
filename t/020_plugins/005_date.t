use strict;
use warnings;
use utf8;
use Test::Base;
use OreOre::Validator;
use CGI;

OreOre::Validator->load_plugins(qw/Date/);

plan tests => 2;

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

=== DATE
--- query: { y => 2009, m => 2, d => 30 }
--- rule
(
    {date => [qw/y m d/]} => ['DATE'],
)
--- expected
(
    date => 1,
)

=== DATE
--- query: { y => 2009, m => 2, d => 28 }
--- rule
(
    {date => [qw/y m d/]} => ['DATE'],
)
--- expected
(
    date => 0,
)

