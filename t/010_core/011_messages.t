#!/usr/bin/env perl -I lib
use strict;
use warnings;
use utf8;
use Test::More 0.96;
use FormValidator::Lite::Messages::en;
use FormValidator::Lite::Messages::ja;

is_deeply(
    [keys %$FormValidator::Lite::Messages::en::MESSAGES],
    [keys %$FormValidator::Lite::Messages::ja::MESSAGES],
    'translated'
);

done_testing;

