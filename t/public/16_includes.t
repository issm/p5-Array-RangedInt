use strict;
use warnings;
use Test::More;
use t::Util;

subtest 'single parameter' => sub {
    subtest 'simple, vs single' => sub {
        my $a = new(-3, -1, 0, 1, 3, 5);
        is $a->includes(-3), 1;
        is $a->includes(-2), 0;
        is $a->includes(-1), 1;
        is $a->includes(0), 1;
        is $a->includes(1), 1;
        is $a->includes(3), 1;
        is $a->includes(5), 1;
        is $a->includes(2), 0;
    };

    subtest 'simple, vs ranged' => sub {
        my $a = new(-5, -3, -2, -1, 0, 1, 3, 5, 6, 7, 9, 10);
        is $a->includes('-5--3'), 0;
        is $a->includes('-5:-3'), 0;
        is $a->includes('-3--1'), 1;
        is $a->includes('-3:-1'), 1;
        is $a->includes('-3-0'), 1;
        is $a->includes('-3:0'), 1;
        is $a->includes('-2-1'), 1;
        is $a->includes('-2:1'), 1;
        is $a->includes('1-3'), 0;
        is $a->includes('1-5'), 0;
        is $a->includes('5-6'), 1;
        is $a->includes('5-7'), 1;
        is $a->includes('9-10'), 1;
        is $a->includes('7-10'), 0;
    };

    subtest 'ranged, vs single' => sub {
        my $a;

        $a = new('1-3');
        is $a->includes(0), 0;
        is $a->includes(1), 1;
        is $a->includes(2), 1;
        is $a->includes(3), 1;
        is $a->includes(4), 0;

        $a = new('-3:-1', '2-4');
        is $a->includes(-4), 0;
        is $a->includes(-3), 1;
        is $a->includes(-2), 1;
        is $a->includes(-1), 1;
        is $a->includes(0), 0;
        is $a->includes(1), 0;
        is $a->includes(2), 1;
        is $a->includes(3), 1;
        is $a->includes(4), 1;
        is $a->includes(5), 0;
    };

    subtest 'ranged, vs ranged' => sub {
        my $a = new('-5:-3', '0-2', '4-5');
        is $a->includes('-5--3'), 1;
        is $a->includes('-5:-3'), 1;
        is $a->includes('-3:1'), 0;
        is $a->includes('0-1'), 1;
        is $a->includes('1-2'), 1;
        is $a->includes('2-3'), 0;
        is $a->includes('4-5'), 1;
    };

    subtest 'mixed, vs single' => sub {
        my $a = new('-5:-3', -1, '0-3', 5, 7, '8-10');
        is $a->includes(-6), 0;
        is $a->includes(-5), 1;
        is $a->includes(-2), 0;
        is $a->includes(-1), 1;
        is $a->includes(0), 1;
        is $a->includes(6), 0;
        is $a->includes(10), 1;
    };

    subtest 'mixed, vs ranged' => sub {
        my $a = new('-5:-3', -1, '0-3', 5, 7, '8-10');
        is $a->includes('-6:-4'), 0;
        is $a->includes('-5:-4'), 1;
        is $a->includes('-5:-3'), 1;
        is $a->includes('-1:-0'), 1;
        is $a->includes('-1:-3'), 1;
        is $a->includes('3-7'), 0;
        is $a->includes('7-9'), 1;
        is $a->includes('7-10'), 1;
    };
};

subtest 'multiple parameters' => sub {
    subtest 'simple, vs single' => sub {
        my $a = new(1, 3, 5, 9, 10);
        is_deeply [$a->includes(1, 3)], [1, 1];
        is_deeply [$a->includes(1, 5, 10)], [1, 1, 1];
        is_deeply [$a->includes(1, 2, 3)], [1, 0, 1];
        is_deeply [$a->includes(5..10)], [1, 0, 0, 0, 1, 1];
    };

    subtest 'simple, vs ranged' => sub {
        my $a = new(-3, -2, 0, 1, 2, 3, 5, 9, 10);
        is_deeply [$a->includes('-4:-2', '-3:-2', '-2:0', '0-3', '5-10')], [0, 1, 0, 1, 0];
    };

    subtest 'simple, vs mixed' => sub {
        my $a = new(-3, -2, 0, 1, 2, 3, 5, 9, 10);
        is_deeply [$a->includes(-4, '-3:-2', '0-3', 1, 2, '5-10', 9)], [0, 1, 1, 1, 1, 0, 1];
    };

    subtest 'ranged, vs single' => sub {
        my $a = new('-5:-3', '0-2', '4-5');
        is_deeply [$a->includes(-6, -5, -3, 0, 1, 3, 5)], [0, 1, 1, 1, 1, 0, 1];
    };

    subtest 'ranged, vs ranged' => sub {
        my $a = new('-5:-3', '0-2', '4-5');
        is_deeply [$a->includes('-6:-4', '-5:-4', '-3:0', '0-1', '2-3', '4-5')], [0, 1, 0, 1, 0, 1];
    };

    subtest 'ranged, vs mixed' => sub {
        my $a = new('-5:-3', '0-2', '4-5');
        is_deeply [$a->includes(-4, '-4:-3', -1, '0-1', 2, 3, '4-5', 6)], [1, 1, 0, 1, 1, 0, 1, 0];
    };

    subtest 'mixed, vs single' => sub {
        my $a = new('-5:-3', -1, '0-3', 5, 7, '8-10');
        is_deeply [$a->includes(-6, -4, -2, -1, 1, 3, 5, 8)], [0, 1, 0, 1, 1, 1, 1, 1];
    };

    subtest 'mixed, vs ranged' => sub {
        my $a = new('-5:-3', -1, '0-3', 5, 7, '8-10');
        is_deeply [$a->includes('-6:-4', '-5:-4', '-3:0', '-1:2', '5-7', '7-10')], [0, 1, 0, 1, 0, 1];
    };

    subtest 'mixed, vs mixed' => sub {
        my $a = new('-5:-3', -1, '0-3', 5, 7, '8-10');
        is_deeply [$a->includes(-4, '-4:-3', -1, '0-1', 2, 3, '4-5', 6)], [1, 1, 1, 1, 1, 1, 0, 0];
    };
};

done_testing;
