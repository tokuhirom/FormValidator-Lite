use strict;
use warnings;
use utf8;
use Test::Base;
use FormValidator::Lite;
use CGI;

FormValidator::Lite->load_constraints(qw/Date/);

plan tests => 1*blocks;

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

=== DATE-NOT_NULL
--- query: {  }
--- rule
(
    {date => [qw/y m d/]} => ['DATE', 'NOT_NULL'],
)
--- expected
(
    date => 1,
)

=== DATE-NOT_NULL
--- query: {  }
--- rule
(
    {date => [qw/y m d/]} => ['NOT_NULL'],
)
--- expected
(
    date => 1,
)

=== DATE
--- query: { date => '2009-02-28' }
--- rule
(
    date => ['DATE'],
)
--- expected
(
    date => 0,
)

=== DATE with blank arg.
--- query: { y => '', m => '', d => ''}
--- rule
(
    {date => [qw/y m d/]} => ['DATE'],
)
--- expected
(
    date => 1,
)

