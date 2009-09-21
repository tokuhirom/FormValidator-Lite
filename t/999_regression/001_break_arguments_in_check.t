# 17:34 craftwor_@f1:> check メソッドで、Line 43
# 17:34 craftwor_@f1:> shift(@$rule) していますが、
# 17:36 craftwor_@f1:> @rule_ary をレキシカルでない変数で渡していると、元の配列に shift
# で変更が加わってしまい、リクエスト毎にルールの要素が減っていってしまいます
# 17:37 craftwor_@f1:> ですので、(@$rule)[0] にしたらいいのかなと思うのですがいかがでしょう？
# 17:41 craftwor_@f1:> 具体的にどう使っているかというと、__PACKAGE__->config( 'constraints' => { 'foo' => [ bar => [qw/NOT_NULL/] ] })
# みたいにしています。
# 18:44 craftwor_@f1:> 前言撤回です。shift しないとルールの内容が正しく渡りませんね…
# 19:00 craftwor_@f1:> check() に渡すデータを Clone::clone して渡すことで対応しました
# 19:18 craftwor_@f1:> check() 側で (@$rule)[0] と、(@$rule)[1..$#$rule] にするというのはどうでしょう。
use strict;
use warnings;
use Test::More;
use FormValidator::Lite;

use CGI;

my @rule = (
    name => [['REGEX', 'hoge']],
);

my $fvl = FormValidator::Lite->new(CGI->new());
$fvl->check(@rule);
is_deeply \@rule, ['name' => [['REGEX', 'hoge']]];

done_testing;
