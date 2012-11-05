use strict;
use warnings;
use utf8;
use Test::Base::Less;
use FormValidator::Lite 'File';
use CGI;

filters {
    input => [qw/eval/],
    rule => [qw/eval/],
};

for my $block (blocks) {
    my $v = FormValidator::Lite->new(CGI->new($block->input));
    $v->check(
        f => $block->rule
    );
    is($v->has_error, $block->expected, $block->name);
}

done_testing;

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

