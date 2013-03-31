use strict;
use warnings;
use utf8;
use Test::Base::Less;
use FormValidator::Lite;
use CGI;

FormValidator::Lite->load_constraints(qw(Number));

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

=== BETWEEN
--- query: { num => 5 }
--- rule
(
    num => [
        [BETWEEN => 1, 10],
    ],
)
--- expected
(
    num => 0,
)

=== BETWEEN
--- query: { num => 5 }
--- rule
(
    num => [
        [BETWEEN => 6, 10],
    ],
)
--- expected
(
    num => 1,
)

=== BETWEEN
--- query: { num => 5 }
--- rule
(
    num => [
        [BETWEEN => 1, 4],
    ],
)
--- expected
(
    num => 1,
)

=== LESS_THAN
--- query: { num => 5 }
--- rule
(
    num => [
        [LESS_THAN => 5],
    ],
)
--- expected
(
    num => 1,
)

=== LESS_THAN
--- query: { num => 5 }
--- rule
(
    num => [
        [LESS_THAN => 6],
    ],
)
--- expected
(
    num => 0,
)

=== LESS_EQUAL
--- query: { num => 5 }
--- rule
(
    num => [
        [LESS_EQUAL => 5],
    ],
)
--- expected
(
    num => 0,
)

=== LESS_EQUAL
--- query: { num => 5 }
--- rule
(
    num => [
        [LESS_EQUAL => 4],
    ],
)
--- expected
(
    num => 1,
)

=== MORE_THAN
--- query: { num => 5 }
--- rule
(
    num => [
        [MORE_THAN => 5],
    ],
)
--- expected
(
    num => 1,
)

=== MORE_THAN
--- query: { num => 5 }
--- rule
(
    num => [
        [MORE_THAN => 4],
    ],
)
--- expected
(
    num => 0,
)

=== MORE_EQUAL
--- query: { num => 5 }
--- rule
(
    num => [
        [MORE_EQUAL => 5],
    ],
)
--- expected
(
    num => 0,
)

=== MORE_EQUAL
--- query: { num => 5 }
--- rule
(
    num => [
        [MORE_THAN => 6],
    ],
)
--- expected
(
    num => 1,
)
