use inc::Module::Install;
include 'Module::AutoInstall';

name 'Algorithm-EquivalenceSets';
all_from 'lib/Algorithm/EquivalenceSets.pm';
perl_version '5.006';

requires 'YAML';

build_requires 'Test::More' => '0.70';
build_requires 'Test::Compile';

auto_install;
auto_include;
WriteAll;
