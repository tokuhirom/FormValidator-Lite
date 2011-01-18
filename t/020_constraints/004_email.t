use strict;
use warnings;
use utf8;
use Test::Base;
use FormValidator::Lite;
use CGI;
use Test::Requires 'Email::Valid';
use Test::Requires 'Email::Valid::Loose';

FormValidator::Lite->load_constraints(qw/Email/);

plan tests => 6;

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

=== EMAIL
--- query: { p1 => 'http://example.com/', p2 => 'foobar@example.com', p3 => 'foo..bar.@example.com' }
--- rule
(
    p1 => ['EMAIL'],
    p2 => ['EMAIL'],
    p3 => ['EMAIL'],
);
--- expected
(
    p1 => 1,
    p2 => 0,
    p3 => 1,
)

=== EMAIL_LOOSE
--- query: { p1 => 'http://example.com/', p2 => 'foobar@example.com', p3 => 'foo..bar.@example.com' }
--- rule
(
    p1 => ['EMAIL_LOOSE'],
    p2 => ['EMAIL_LOOSE'],
    p3 => ['EMAIL_LOOSE'],
);
--- expected
(
    p1 => 1,
    p2 => 0,
    p3 => 0,
)

