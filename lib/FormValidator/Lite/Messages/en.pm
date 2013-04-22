package FormValidator::Lite::Messages::en;
use strict;
use warnings;
use utf8;

# TODO: we need english message profile
our $MESSAGES = {
    not_null => 'please input [_1]',
    int      => 'please input [_1] as integer',
    ascii => 'Please input [_1] as ASCII',
    date => '[_1] is not valid date',
    duplication => 'Please same [_1] twice',
    length => '[_1] have bad length',
    regex => '[_1] is not good',
    uint => 'Please input [_1] as unsigned int',

    # http-url
    http_url => 'please input [_1] as url',

    # email
    email_loose => 'Please input [_1] as E-mail address',

    # japanese
    hiragana => 'Please input [_1] as Hiragana',
    jtel => 'Please input [_1] as telephone number',
    jzip => 'Please input [_1] as zip number',
    katakana => 'Please input [_1] as Katakana',

    # file
    file_size => '[_1] have bad file size',
    file_mime => '[_1] have bad mime type',
};

1;
__END__

=head1 NAME

FormValidator::Lite::Messages::en - English language resource

=head1 DESCRIPTION

This module provides English message set for L<FormValidator::Lite>.


