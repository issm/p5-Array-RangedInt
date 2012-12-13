use strict;
use warnings;
use Test::More;
use t::Util;

subtest 'single' => sub {
    my $a = new();

    $a->add(1);
    is_deeply $a->{_items}, [1];

    $a->add(2, 3);
    is_deeply $a->{_items}, ['1-3'];

    subtest 'continuous calling' => sub {
        my $a;
        $a = new();
        $a->add(1)  for 1..5;
        is_deeply $a->{_items}, [1];

        $a = new(1);
        $a->add(2)  for 1..5;
        is_deeply $a->{_items}, ['1-2'];

        $a = new(1);
        $a->add(3)  for 1..5;
        is_deeply $a->{_items}, [1, 3];

        $a = new('1-2');
        $a->add(3)  for 1..5;
        is_deeply $a->{_items}, ['1-3'];
    };
};

subtest 'ranged' => sub {
    my $a = new();

    $a->add('1-2');
    is_deeply $a->{_items}, ['1-2'];

    $a->add('2-3');
    is_deeply $a->{_items}, ['1-3'];

    $a->add('5-8', '-5:-3');
    is_deeply $a->{_items}, ['-5--3', '1-3', '5-8'];

    $a->add('6-10');
    is_deeply $a->{_items}, ['-5--3', '1-3', '5-10'];

    subtest 'continuous calling' => sub {
        my $a = new();
        $a->add('1-3')  for 1..5;
        is_deeply $a->{_items}, ['1-3'];

        $a->add('3-5')  for 1..5;
        is_deeply $a->{_items}, ['1-5'];

        $a->add('8-10')  for 1..5;
        is_deeply $a->{_items}, ['1-5', '8-10'];
    };
};

subtest 'mixed' => sub {
    my $a = new(-6, '-4:-2', '0-3', 4, '8-10');

    $a->add(5, '10-12', 15);
    is_deeply $a->{_items}, [-6, '-4--2', '0-5', '8-12', 15];

    $a->add(-5, '-10:-8');
    is_deeply $a->{_items}, ['-10--8', '-6--2', '0-5', '8-12', 15];
};

done_testing;
