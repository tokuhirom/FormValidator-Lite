use strict;
use warnings;
use utf8;
use Test::More tests => 2;
use FormValidator::Lite;
use CGI;
use YAML;

# test get_error_message
my $v = FormValidator::Lite->new(CGI->new({}));
$v->set_error('baz' => 'NOT_NULL');
$v->set_error('baz' => 'HIRAGANA');
$v->set_error('zip' => 'JZIP');
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
is_deeply([$v->get_error_messages], YAML::Load(<<'...'), 'order is assured');
---
- ばずがからっぽです
- ばずがひらがなじゃありません
- 郵便番号をただしく入力してください
...

is_deeply([$v->get_error_messages], scalar($v->get_error_messages), 'context');

