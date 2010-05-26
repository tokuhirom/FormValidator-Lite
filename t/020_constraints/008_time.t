use strict;
use warnings;
use utf8;
use Test::Base;
use FormValidator::Lite;
use CGI;

FormValidator::Lite->load_constraints(qw/Time/);

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

=== TIME should success
--- query: { h => 12, m => 0, s => 30 }
--- rule
(
    {date => [qw/h m s/]} => ['TIME'],
)
--- expected
(
    date => 0,
)
 
=== TIME should fail
--- query: { h => 24, m => 0, s => 0 }
--- rule
(
    {date => [qw/h m s/]} => ['TIME'],
)
--- expected
(
    date => 1,
)

=== TIME-NOT_NULL
--- query: {  }
--- rule
(
    {date => [qw/h m s/]} => ['TIME', 'NOT_NULL'],
)
--- expected
(
    date => 1,
)

=== TIME-NOT_NULL
--- query: {  }
--- rule
(
    {date => [qw/h m s/]} => ['NOT_NULL'],
)
--- expected
(
    date => 1,
)

=== TIME
--- query: { time => '12:30:00' }
--- rule
(
    date => ['TIME'],
)
--- expected
(
    date => 0,
)

=== TIME should not warn with ''
--- query: { h => '', m => '', s => ''}
--- rule
(
    {date => [qw/h m s/]} => ['TIME'],
)
--- expected
(
    date => 1,
)
 
