package FormValidator::Lite::Constraint::Japanese;
use strict;
use warnings;
use FormValidator::Lite::Constraint;

rule 'HIRAGANA' => sub { delsp($_) =~ /^\p{InHiragana}+$/  };
rule 'KATAKANA' => sub { delsp($_) =~ /^\p{InKatakana}+$/  };
rule 'JTEL'     => sub { $_ =~ /^0\d+\-?\d+\-?\d+$/        };
rule 'JZIP'     => sub { $_ =~ /^\d{3}\-\d{4}$/            };

1;
__END__

=head1 NAME

FormValidator::Lite::Constraint::Japanese - constraints for Japanese

=head1 CONSTRAINTS

=over 4

=item HIRAGANA

Check valid Hiragana or not.

=item KATAKANA

Check valid Katakana or not.

=item JTEL

Check valid Japanese telephone number or not.

=item JZIP

Check valid Japanese ZIP number or not.

=back



