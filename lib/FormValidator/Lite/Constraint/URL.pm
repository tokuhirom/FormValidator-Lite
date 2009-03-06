package FormValidator::Lite::Constraint::URL;
use FormValidator::Lite::Constraint;

# this regexp is taken from http://www.din.or.jp/~ohzaki/perl.htm#httpURL
# thanks to ohzaki++
rule 'HTTP_URL' => sub {
    $_ =~ /^s?https?:\/\/[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+$/
};

1;
