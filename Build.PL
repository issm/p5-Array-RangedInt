use 5.008;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->subclass(
    code => q{
        # run prove
        sub ACTION_test {
            my $self = shift;
            my $tests = $self->find_test_files;

            require App::Prove;
            my $prove = App::Prove->new();
            $prove->process_args('-l', @$tests);
            $prove->run();
        }
    }
)->new(
    name                => 'Array::RangedInt',
    module_name         => 'Array::RangedInt',
    license             => 'perl',
    dist_author         => q{IWATA, Susumu <issmxx@gmail.com>},
    dist_version_from   => 'lib/Array/RangedInt.pm',
    release_status      => 'testing',
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

    test_files => (-d '.git' || $ENV{RELEASE_TESTING}) ? 't/ xt/' : 't/',
    recursive_test_files => 1,
);

$builder->create_build_script();
