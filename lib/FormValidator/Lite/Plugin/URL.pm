package FormValidator::Lite::Plugin::URL;
use FormValidator::Lite::Plugin;

# this regexp is taken from http://www.din.or.jp/~ohzaki/perl.htm#httpURL
# thanks to ohzaki++
rule 'HTTP_URL' => sub {
    $_ =~ /^s?https?:\/\/[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+$/
};

1;
