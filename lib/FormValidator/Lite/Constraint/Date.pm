package FormValidator::Lite::Constraint::Date;
use FormValidator::Lite::Constraint;

rule 'DATE' => sub {
    if (ref $_) {
        # query: y=2009&m=09&d=02
        # rule:  {date => [qw/y m d/]} => ['DATE']
        return 0 unless scalar(@{$_}) == 3;
        _v(@{$_});
    } else {
        # query: date=2009-09-02
        # rule:  date => ['DATE']
        _v(split /-/, $_);
    }
};

sub _v {
    my ($y, $m, $d) = @_;

    if ($d > 31 or $d < 1 or $m > 12 or $m < 1 or $y == 0) {
        return 0;
    }
    if ($d > 30 and ($m == 4 or $m == 6 or $m == 9 or $m == 11)) {
        return 0;
    }
    if ($d > 29 and $m == 2) {
        return 0;
    }
    if ($m == 2 and $d > 28 and !($y % 4 == 0 and ($y % 100 != 0 or $y % 400 == 0))){
        return 0;
    }
    return 1;
}


1;
