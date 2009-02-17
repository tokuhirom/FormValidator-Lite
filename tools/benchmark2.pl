use Modern::Perl;
use Benchmark ':all';
use CGI;
use OreOre::Validator; 

my $C = 1000;

my $q = CGI->new;
$q->param( param1 => 'ABCD' );

my $t = timeit(
    $C,
    sub {
        my $result = OreOre::Validator->new($q)->check(
            param1 => [ 'NOT_BLANK', 'ASCII', [ 'LENGTH', 2, 5 ] ],
        );
    }
);
say timestr($t);

