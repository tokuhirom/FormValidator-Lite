package FormValidator::Lite::Constraint::Email;
use FormValidator::Lite::Constraint;
use Email::Valid::Loose;

rule 'EMAIL_LOOSE' => sub {
    Email::Valid::Loose->address($_);
};

1;
