package FormValidator::Lite::Plugin::Date;
use FormValidator::Lite::Plugin;

rule 'DATE' => sub {
    return 0 unless scalar(@{$_}) == 3;

    my ($y, $m, $d) = @{$_};
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
};

1;
