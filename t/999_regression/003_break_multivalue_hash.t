use strict;
use warnings;
use Test::More;
use FormValidator::Lite;
use Test::Requires 'Hash::MultiValue';

my $q = Hash::MultiValue->new(
    a => 1,
    a => 2,
    b => 2,
);

my $validator = FormValidator::Lite->new($q);

is(join(' ', sort $validator->query->param('a')), '1 2');
is(join(' ', sort $validator->query->param('b')), '2');

done_testing;

