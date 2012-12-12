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
};

subtest 'ranged' => sub {
    is new('1-1')->size(), 1;
    is new('1-2')->size(), 2;
    is new('2-1')->size(), 2;
    is new('1-3', '6-8', '10-15')->size(), 12;
    is new('-6:-3', '-1:4')->size(), 10;
};

subtest 'mixed' => sub {
    is new(1, '2-3')->size(), 3;
    is new('1-2', 3)->size(), 3;
    is new('-10:-6', -3, -1, '0-5', 8, 10, 13, '20-25')->size(), 22;
};

done_testing;
