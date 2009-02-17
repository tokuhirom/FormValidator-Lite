use Modern::Perl;
use Benchmark ':all';
use CGI;
use FormValidator::Lite qw/Email Date/; 
use FormValidator::Simple;

my $C = 1000;

my $q = CGI->new;
$q->param( param1 => 'ABCD' );
$q->param( param2 => 12345 );
$q->param( mail1  => 'lyo.kato@gmail.com' );
$q->param( mail2  => 'lyo.kato@gmail.com' );
$q->param( year   => 2005 );
$q->param( month  => 11 );
$q->param( day    => 27 );

cmpthese(
    $C => {
        'FormValidator::Lite' => sub {
            my $result = FormValidator::Lite->new($q)->check(
                param1 => [ 'NOT_BLANK', 'ASCII', [ 'LENGTH', 2, 5 ] ],
                param2 => [ 'NOT_BLANK', 'INT' ],
                mail1  => [ 'NOT_BLANK', 'EMAIL_LOOSE' ],
                mail2  => [ 'NOT_BLANK', 'EMAIL_LOOSE' ],
                { mails => [ 'mail1', 'mail2' ] } => ['DUPLICATION'],
                { date => [ 'year', 'month', 'day' ] } => ['DATE'],
            );
        },
        'FormValidator::Simple' => sub {
            my $result = FormValidator::Simple->check(
                $q => [
                    param1 => [ 'NOT_BLANK', 'ASCII', [ 'LENGTH', 2, 5 ] ],
                    param2 => [ 'NOT_BLANK', 'INT' ],
                    mail1  => [ 'NOT_BLANK', 'EMAIL_LOOSE' ],
                    mail2  => [ 'NOT_BLANK', 'EMAIL_LOOSE' ],
                    { mails => [ 'mail1', 'mail2' ] } => ['DUPLICATION'],
                    { date => [ 'year', 'month', 'day' ] } => ['DATE'],
                ]
            );
        },
    },
);

