package FormValidator::Lite::Messages::ja;
use strict;
use warnings;
use utf8;

our $MESSAGES = {
    not_null => '[_1] を入力してください',
    int      => '[_1] は整数で入力してください',
    ascii => '[_1] は半角で入力してください',
    date => '[_1] が日付として正しくありません',
    duplication => '[_1] は正しく2回入力してください',
    length => '[_1] の長さがちがいます',
    regex => '[_1] がただしくありません',
    uint => '[_1] は正の整数で入力してください',

    # http-url
    http_url => '[_1] には URL を入力してください',

    # email
    email_loose => '[_1] にはメールアドレスを入力してください',

    # japanese
    hiragana => '[_1] にはひらがなで入力してください',
    jtel => '[_1] には電話番号をただしく入力してくさい',
    jzip => '[_1] には郵便番号を正しく入力してください',
    katakana => '[_1] にはカタカナで入力してください',

    # file
    file_size => '[_1] のファイルサイズがただしくありません',
    file_mime => '[_1] のファイルタイプがただしくありません',
};

1;
__END__

=head1 NAME

FormValidator::Lite::Messages::ja - Japanese language resource

=head1 DESCRIPTION

This module provides Japanese message set for L<FormValidator::Lite>.


