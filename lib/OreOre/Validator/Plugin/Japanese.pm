package OreOre::Validator::Plugin::Japanese;
use OreOre::Validator::Plugin;

rule 'HIRAGANA' => sub { delsp($_) =~ /^\p{InHiragana}+$/  };
rule 'KATAKANA' => sub { delsp($_) =~ /^\p{InKatakana}+$/  };
rule 'JTEL'     => sub { $_ =~ /^0\d+\-?\d+\-?\d+$/        };
rule 'JZIP'     => sub { $_ =~ /^\d{3}\-\d{4}$/            };

1;
