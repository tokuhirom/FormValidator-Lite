package FormValidator::Lite::Messages::ja;
use strict;
use warnings;
use utf8;

our $MESSAGES = {
    not_null => '%s を入力してください',
    int      => '%S は整数で入力してください',
    ascii => '%s は半角で入力してください',
    date => '%s が日付として正しくありません',
    duplication => '%s は正しく2回入力してください',
    length => '%s の長さがちがいます',
    regex => '%s がただしくありません',
    uint => '%s は正の整数で入力してください',

    # http-url
    http_url => '%s には URL を入力してください',

    # email
    email_loose => '%s にはメールアドレスを入力してください',

    # japanese
    hiragana => '%s にはひらがなで入力してください',
    jtel => '%s には電話番号をただしく入力してくさい',
    jzip => '%s には郵便番号を正しく入力してください',
    katakana => '%s にはカタカナで入力してください',

    # file
    file_size => '%s のファイルサイズがただしくありません',
    file_mime => '%s のファイルタイプがただしくありません',
};

1;
