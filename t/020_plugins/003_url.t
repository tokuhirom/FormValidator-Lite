use strict;
use warnings;
use utf8;
use Test::Base;
use OreOre::Validator;
use CGI;

OreOre::Validator->load_plugins(qw/URL/);

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

=== HTTP_URL
--- query: { p1 => 'http://example.com/', p2 => 'foobar', }
--- rule
(
    p1 => ['HTTP_URL'],
    p2 => ['HTTP_URL'],
);
--- expected
(
    p1 => 0,
    p2 => 1,
)

