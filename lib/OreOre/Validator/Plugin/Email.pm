package OreOre::Validator::Plugin::Email;
use OreOre::Validator::Plugin;
use Email::Valid::Loose;

rule 'EMAIL_LOOSE' => sub {
    Email::Valid::Loose->address($_);
};

1;
