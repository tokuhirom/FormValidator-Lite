package FormValidator::Lite::Constraint::Email;
use strict;
use warnings;
use FormValidator::Lite::Constraint;
use Email::Valid;
use Email::Valid::Loose;

rule 'EMAIL' => sub {
    Email::Valid->address($_);
};

rule 'EMAIL_LOOSE' => sub {
    Email::Valid::Loose->address($_);
};

1;
__END__

=head1 NAME

FormValidator::Lite::Constraint::Email - E-Mail address validation

=head1 CONSTRAINTS

=over 4

=item EMAIL

    $validator->check(
        email => [qw/EMAIL/],
    );

Check the parameter is valid E-Mail address or not.
If you are Japanese programmer, you would use EMAIL_LOOSE instead.

This constraint uses L<Email::Valid>.

=item EMAIL_LOOSE

    $validator->check(
        email => [qw/EMAIL_LOOSE/],
    );

Check the parameter is valid E-Mail address or not. But allow some "loose" addresses.

This constraint uses L<Email::Valid::Loose>.

=back

=head1 SEE ALSO

L<Email::Valid::Loose>, L<FormValidator::Lite>

