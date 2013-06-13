use strict;
use warnings;
use utf8;
use Test::More tests => 1;
use FormValidator::Lite;

my $v = FormValidator::Lite->new({});
my $m = $v->build_message("[_1] is [_2]", "foo", "bar");
is $m, "foo is bar";
