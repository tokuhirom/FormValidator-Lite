use strict;
use warnings;
use CGI;
use FormValidator::Lite qw/Email Date/; 

my $q = CGI->new;
$q->param( param1 => 'ABCD' );
$q->param( param2 => 12345 );
$q->param( mail1  => 'lyo.kato@gmail.com' );
$q->param( mail2  => 'lyo.kato@gmail.com' );
$q->param( year   => 2005 );
$q->param( month  => 11 );
$q->param( day    => 27 );

for (0..1000) {
    my $result = FormValidator::Lite->new($q)->check(
        param1 => [ 'NOT_BLANK', 'ASCII', [ 'LENGTH', 2, 5 ] ],
        param2 => [ 'NOT_BLANK', 'INT' ],
        mail1  => [ 'NOT_BLANK', 'EMAIL_LOOSE' ],
        mail2  => [ 'NOT_BLANK', 'EMAIL_LOOSE' ],
        { mails => [ 'mail1', 'mail2' ] } => ['DUPLICATION'],
        { date => [ 'year', 'month', 'day' ] } => ['DATE'],
    );
    $result->has_error;
}

