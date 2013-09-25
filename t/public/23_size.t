use strict;
use warnings;
use Test::More;
use t::Util;

subtest 'empty' => sub {
    is new()->size(), 0;
};

subtest 'single' => sub {
    is new(1)->size(), 1;
    is new(1, 2, 3)->size(), 3;
    is new(-5, -3, 0, 3, 5)->size(), 5;

    is new('01')->size(), 1;
    is new('01', '010')->size(), 2;
};

subtest 'ranged' => sub {
    is new('1-1')->size(), 1;
    is new('1-2')->size(), 2;
    is new('2-1')->size(), 2;
    is new('10-20')->size(), 11;
    is new('1-3', '6-8', '10-15')->size(), 12;
    is new('-6:-3', '-1:4')->size(), 10;
    is new('-11:-6', '-1:4', '8-12')->size(), 17;

    is new('010-020')->size(), 11;
    is new('-011:-06', '-01:04', '08-012')->size(), 17;
};

subtest 'mixed' => sub {
    is new(1, '2-3')->size(), 3;
    is new('1-2', 3)->size(), 3;
    is new('-10:-6', -3, -1, '0-5', 8, 10, 13, '20-25')->size(), 22;

    is new(10, '010')->size(), 1;

    is new(1, '02-03')->size(), 3;
    is new('01-02', 3)->size(), 3;
    is new('-010:-06', '-03', -1, '0-05', '08', 10, '013', '020-025')->size(), 22;
};

done_testing;
