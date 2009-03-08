use strict;
use warnings;
use utf8;
use Test::Base;
use FormValidator::Lite 'File';
use CGI;

plan tests => 1*blocks;

filters {
    input => [qw/eval/],
    rule => [qw/eval/],
};

run {
    my $block = shift;
    my $v = FormValidator::Lite->new(CGI->new($block->input));
    $v->check(
        f => $block->rule
    );
    is($v->has_error, $block->expected, $block->name);
};

__END__

===
--- input: {f => 3}
--- rule: [['CHOICE' => [qw/1 2 3/]]]
--- expected: 0

===
--- input: {f => 9}
--- rule: [['CHOICE' => [qw/1 2 3/]]]
--- expected: 1

===
--- input: {f => 9}
--- rule: [['CHOICE' => qw(1 2 3)]]
--- expected: 1

===
--- input: {f => 9}
--- rule: [['CHOICE' => qw(9 2 3)]]
--- expected: 0

