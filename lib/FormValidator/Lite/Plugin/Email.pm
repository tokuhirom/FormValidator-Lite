package FormValidator::Lite::Plugin::Email;
use FormValidator::Lite::Plugin;
use Email::Valid::Loose;

rule 'EMAIL_LOOSE' => sub {
    Email::Valid::Loose->address($_);
};

1;
