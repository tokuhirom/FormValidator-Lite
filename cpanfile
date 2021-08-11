requires 'Class::Accessor::Lite', '0.05';
requires 'Class::Load', '0.11';
requires 'Email::Valid';
requires 'Email::Valid::Loose';
requires 'Filter::Util::Call';
requires 'Scalar::Util', '1.19';
requires 'perl', '5.008001';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'CGI', '3.31,!=4.05,!=4.06,!=4.07,!=4.08';
    requires 'Test::Base::Less';
    requires 'Test::More', '0.98';
    requires 'Test::Requires', '0.05';
    requires 'YAML';
    recommends 'Hash::MultiValue';
    suggests 'HTTP::Engine::Request';
    suggests 'HTML::Shakan';
};
