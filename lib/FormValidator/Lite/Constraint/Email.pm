package FormValidator::Lite::Constraint::Email;
use FormValidator::Lite::Constraint;
use Email::Valid::Loose;

rule 'EMAIL_LOOSE' => sub {
    Email::Valid::Loose->address($_);
};

1;
__END__

=head1 NAME

FormValidator::Lite::Constraint::Email - E-Mail address validation

=head1 CONSTRAINTS

=over 4

=item EMAIL_LOOSE

    $validator->check(
        email => [qw/EMAIL_LOOSE/],
    );

Check the parameter is valid E-Mail address or not.

This constraint uses L<Email::Valid::Loose>.

=back

=head1 SEE ALSO

L<Email::Valid::Loose>, L<FormValidator::Lite>

