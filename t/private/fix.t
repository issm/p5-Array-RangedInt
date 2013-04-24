use strict;
use warnings;
use Test::More;
use t::Util;

my $a = new();

subtest 'single' => sub {
    is $a->_fix(1), 1;
    is $a->_fix('1'), 1;
    is_deeply [$a->_fix(1, 2, 3)], [1, 2, 3];
};

subtest 'ranged' => sub {
    subtest 'a-b' => sub {
        is $a->_fix('1-5'), '1-5';
        is $a->_fix('5-1'), '1-5';
        is_deeply [$a->_fix('1-5', '2-5', '10-8', '5-3')], ['1-5', '2-5', '8-10', '3-5'];
    };

    subtest 'a-a' => sub {
        is $a->_fix('1-1'), 1;
        is_deeply [$a->_fix('1-1', '2-2', '3-3')], [1, 2, 3];
    };

    subtest 'mixed' => sub {
        is_deeply [$a->_fix('1-5','5-2', '3-3')], ['1-5', '2-5', 3];
    };
};

subtest 'mixed' => sub {
    is_deeply [$a->_fix(1, '2-5', '10-6', '4-4', 3)], [1, '2-5', '6-10', 4, 3];
};

done_testing;
