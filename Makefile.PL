use inc::Module::Install;
name 'OreOre-Validator';
all_from 'lib/OreOre/Validator.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
