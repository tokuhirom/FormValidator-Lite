use strict;
use warnings;
use utf8;
use Test::More tests => 3;
use FormValidator::Lite;
use CGI;
use YAML;

# test get_error_message
my $v = FormValidator::Lite->new(CGI->new({}));
$v->set_message_data(YAML::Load(<<'...'));
---
message:
  zip.jzip: 郵便番号をただしく入力してください
param:
  foo: ふう
  bar: ばあ
  baz: ばず
function:
  not_null: "[_1]がからっぽです"
  hiragana: "[_1]がひらがなじゃありません"
...
is($v->get_error_message('baz', 'NOT_NULL'), 'ばずがからっぽです');
is($v->get_error_message('baz', 'HIRAGANA'), 'ばずがひらがなじゃありません');
is($v->get_error_message('zip', 'JZIP'), '郵便番号をただしく入力してください');

