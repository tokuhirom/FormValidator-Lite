use strict;
use warnings;
use utf8;
use Test::Base::Less;
use FormValidator::Lite;
use CGI;

FormValidator::Lite->load_constraints(qw/URL/);

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

