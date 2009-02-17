use strict;
use warnings;
use Test::More tests => 2;
use OreOre::Validator;
use CGI;

{
    my $q1 = CGI->new({mail1 => 'foo@example.com', mail2 => 'foo@example.com'});
    my $v = OreOre::Validator->new($q1)->check(
        {mails => [qw/mail1 mail2/] } => [qw/DUPLICATION/],
    );
    is($v->is_error('mails'), 0);
}

{
    my $q2 = CGI->new({mail1 => 'foo@example.com', mail2 => 'bar@example.com'});
    my $v = OreOre::Validator->new($q2)->check(
        {mails => [qw/mail1 mail2/] } => [qw/DUPLICATION/],
    );
    is($v->is_error('mails'), 1);
}

