use inc::Module::Install;
name 'FormValidator-Lite';
all_from 'lib/FormValidator/Lite.pm';

requires 'UNIVERSAL::require' => 0.11;
requires 'Scalar::Util' => 1.19; #older Scalar::Util has bug
requires 'Class::Accessor::Lite' => 0.05;

# CGI < 3.31 has a OSX depended bug.
# > 2. Patch from Alexander Klink to select correct temporary directory in OSX Leopard so that upload works.
requires 'CGI' => 3.31;

test_requires 'Test::Requires' => 0.05;

recommends 'Email::Valid';
recommends 'Email::Valid::Loose';

tests('t/*.t t/*/*.t t/*/*/*.t');
author_tests('xt');

build_requires 'Test::More';
test_requires 'YAML';
use_test_base;
auto_include;
WriteAll;
