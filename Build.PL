use 5.008;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Array::RangedInt',
    license             => 'Perl_5',
    dist_author         => q{IWATA, Susumu <issmxx@gmail.com>},
    dist_version_from   => 'lib/Array/RangedInt.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    add_to_cleanup     => [ 'Array-RangedInt-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();