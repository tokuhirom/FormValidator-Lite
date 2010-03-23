use Test::More;
eval q{ use Test::Spelling };
plan skip_all => "Test::Spelling is not installed." if $@;
add_stopwords(map { split /[\s\:\-]/ } <DATA>);
$ENV{LANG} = 'C';
all_pod_files_spelling_ok('lib');
__DATA__
Default Name
default {at} example.com
FormValidator::Lite
PLUGINS
api
Tokuhiro
Matsuno
craftworks
CGI
nekokak
param
pm
HIRAGANA
Hiragana
KATAKANA
Katakana
URL
URI
UINT
JTEL
JZIP
DUP
