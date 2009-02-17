use inc::Module::Install;
name 'FormValidator-Lite';
all_from 'lib/FormValidator/Lite.pm';

requires 'UNIVERSAL::require' => 0.11;
requires 'Scalar::Util';

tests('t/*.t t/*/*.t t/*/*/*.t');
author_tests('xt');

build_requires 'Test::More';
test_requires 'YAML';
use_test_base;
auto_include;
WriteAll;
