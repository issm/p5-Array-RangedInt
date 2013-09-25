use strict;
use warnings;
use Test::More;
use t::Util;

subtest 'single parameter' => sub {
    subtest 'simple, vs single' => sub {
        my $a = new(-10, -8, -3, -1, 0, 1, 3, 5, 8, 10);
        is $a->includes(-10), 1;
        is $a->includes(-9), 0;
        is $a->includes(-8), 1;
        is $a->includes(-3), 1;
        is $a->includes(-2), 0;
        is $a->includes(-1), 1;
        is $a->includes(0), 1;
        is $a->includes(1), 1;
        is $a->includes(3), 1;
        is $a->includes(5), 1;
        is $a->includes(2), 0;
        is $a->includes(8), 1;
        is $a->includes(9), 0;
        is $a->includes(10), 1;

        is $a->includes('-010'), 1;
        is $a->includes('-09'), 0;
        is $a->includes('-08'), 1;
        is $a->includes('-03'), 1;
        is $a->includes('-02'), 0;
        is $a->includes('-01'), 1;
        is $a->includes('0'), 1;
        is $a->includes('01'), 1;
        is $a->includes('03'), 1;
        is $a->includes('05'), 1;
        is $a->includes('02'), 0;
        is $a->includes('08'), 1;
        is $a->includes('09'), 0;
        is $a->includes('010'), 1;
    };

    subtest 'simple, vs ranged' => sub {
        my $a = new(-10, -8, -5, -3, -2, -1, 0, 1, 3, 5, 6, 7, 9, 10);
        is $a->includes('-10--3'), 0;
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

        is $a->includes('-010--03'), 0;
        is $a->includes('-05--03'), 0;
        is $a->includes('-05:-03'), 0;
        is $a->includes('-03--01'), 1;
        is $a->includes('-03:-01'), 1;
        is $a->includes('-03-0'), 1;
        is $a->includes('-03:0'), 1;
        is $a->includes('-02-01'), 1;
        is $a->includes('-02:01'), 1;
        is $a->includes('01-03'), 0;
        is $a->includes('01-05'), 0;
        is $a->includes('05-06'), 1;
        is $a->includes('05-07'), 1;
        is $a->includes('09-010'), 1;
        is $a->includes('07-010'), 0;
    };

    subtest 'ranged, vs single' => sub {
        my $a;

        $a = new('1-8');
        is $a->includes(0), 0;
        is $a->includes(1), 1;
        is $a->includes(2), 1;
        is $a->includes(3), 1;
        is $a->includes(4), 1;
        is $a->includes(5), 1;
        is $a->includes(9), 0;
        is $a->includes(10), 0;

        is $a->includes('0'), 0;
        is $a->includes('01'), 1;
        is $a->includes('02'), 1;
        is $a->includes('03'), 1;
        is $a->includes('04'), 1;
        is $a->includes('010'), 0;

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

        is $a->includes('-04'), 0;
        is $a->includes('-03'), 1;
        is $a->includes('-02'), 1;
        is $a->includes('-01'), 1;
        is $a->includes('0'), 0;
        is $a->includes('01'), 0;
        is $a->includes('02'), 1;
        is $a->includes('03'), 1;
        is $a->includes('04'), 1;
        is $a->includes('05'), 0;
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

        is $a->includes('-05--03'), 1;
        is $a->includes('-05:-03'), 1;
        is $a->includes('-03:01'), 0;
        is $a->includes('0-01'), 1;
        is $a->includes('01-02'), 1;
        is $a->includes('02-03'), 0;
        is $a->includes('04-05'), 1;
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

        is $a->includes('-06'), 0;
        is $a->includes('-05'), 1;
        is $a->includes('-02'), 0;
        is $a->includes('-01'), 1;
        is $a->includes('0'), 1;
        is $a->includes('06'), 0;
        is $a->includes('010'), 1;
    };

    subtest 'mixed, vs ranged' => sub {
        my $a = new('-5:-3', -1, '0-3', 5, 7, '8-10', '11-16');
        is $a->includes('-6:-4'), 0;
        is $a->includes('-5:-4'), 1;
        is $a->includes('-5:-3'), 1;
        is $a->includes('-1:-0'), 1;
        is $a->includes('-1:-3'), 1;
        is $a->includes('3-7'), 0;
        is $a->includes('7-9'), 1;
        is $a->includes('7-10'), 1;
        is $a->includes('15-20'), 0;

        is $a->includes('-06:-04'), 0;
        is $a->includes('-05:-04'), 1;
        is $a->includes('-05:-03'), 1;
        is $a->includes('-01:-00'), 1;
        is $a->includes('-01:-03'), 1;
        is $a->includes('03-07'), 0;
        is $a->includes('07-09'), 1;
        is $a->includes('07-010'), 1;
        is $a->includes('015-020'), 0;
    };
};

subtest 'multiple parameters' => sub {
    subtest 'simple, vs single' => sub {
        my $a = new(1, 3, 5, 9, 10);
        is_deeply [$a->includes(1, 3)], [1, 1];
        is_deeply [$a->includes(1, 5, 10)], [1, 1, 1];
        is_deeply [$a->includes(1, 2, 3)], [1, 0, 1];
        is_deeply [$a->includes(5..10)], [1, 0, 0, 0, 1, 1];

        is_deeply [$a->includes('01', '03')], [1, 1];
        is_deeply [$a->includes('01', '05', '010')], [1, 1, 1];
        is_deeply [$a->includes('01', '02', '03')], [1, 0, 1];
        is_deeply [$a->includes('05', '06', '07', '08', '09', '010')], [1, 0, 0, 0, 1, 1];
    };

    subtest 'simple, vs ranged' => sub {
        my $a = new(-3, -2, 0, 1, 2, 3, 5, 9, 10);
        is_deeply [$a->includes('-4:-2', '-3:-2', '-2:0', '0-3', '5-10')],         [0, 1, 0, 1, 0];
        is_deeply [$a->includes('-04:-02', '-03:-02', '-02:0', '0-03', '05-010')], [0, 1, 0, 1, 0];
    };

    subtest 'simple, vs mixed' => sub {
        my $a = new(-3, -2, 0, 1, 2, 3, 5, 9, 10);
        is_deeply [$a->includes(-4, '-3:-2', '0-3', 1, 2, '5-10', 9)],                  [0, 1, 1, 1, 1, 0, 1];
        is_deeply [$a->includes('-04', '-03:-02', '0-03', '01', '02', '05-010', '09')], [0, 1, 1, 1, 1, 0, 1];
    };

    subtest 'ranged, vs single' => sub {
        my $a = new('-5:-3', '0-2', '4-5', '7-8');
        is_deeply [$a->includes(-6, -5, -3, 0, 1, 3, 5, 8, 9)],                            [0, 1, 1, 1, 1, 0, 1, 1, 0];
        is_deeply [$a->includes('-06', '-05', '-03', '0', '01', '03', '05', '08', '010')], [0, 1, 1, 1, 1, 0, 1, 1, 0];
    };

    subtest 'ranged, vs ranged' => sub {
        my $a = new('-5:-3', '0-2', '4-5', '11-16');
        is_deeply [$a->includes('-6:-4', '-5:-4', '-3:0', '0-1', '2-3', '4-5', '15-20')],             [0, 1, 0, 1, 0, 1, 0];
        is_deeply [$a->includes('-06:-04', '-05:-04', '-03:0', '0-01', '02-03', '04-05', '015-020')], [0, 1, 0, 1, 0, 1, 0];
    };

    subtest 'ranged, vs mixed' => sub {
        my $a = new('-5:-3', '0-2', '4-5', '11-16');
        is_deeply [$a->includes(-4, '-4:-3', -1, '0-1', 2, 3, '4-5', 6, 13, '15-20')],                          [1, 1, 0, 1, 1, 0, 1, 0, 1, 0];
        is_deeply [$a->includes('-04', '-04:-03', '-01', '0-01', '02', '03', '04-05', '06', '013', '015-020')], [1, 1, 0, 1, 1, 0, 1, 0, 1, 0];
    };

    subtest 'mixed, vs single' => sub {
        my $a = new('-5:-3', -1, '0-3', 5, 7, '8-9');
        is_deeply [$a->includes(-6, -4, -2, -1, 1, 3, 5, 8, 10)],                            [0, 1, 0, 1, 1, 1, 1, 1, 0];
        is_deeply [$a->includes('-06', '-04', '-02', '-01', '01', '03', '05', '08', '010')], [0, 1, 0, 1, 1, 1, 1, 1, 0];
    };

    subtest 'mixed, vs ranged' => sub {
        my $a = new('-5:-3', -1, '0-3', 5, 7, '8-10');
        is_deeply [$a->includes('-6:-4', '-5:-4', '-3:0', '-1:2', '5-7', '7-10')],            [0, 1, 0, 1, 0, 1];
        is_deeply [$a->includes('-06:-04', '-05:-04', '-03:0', '-01:02', '05-07', '07-010')], [0, 1, 0, 1, 0, 1];
    };

    subtest 'mixed, vs mixed' => sub {
        my $a = new('-5:-3', -1, '0-3', 5, 7, '8-10');
        is_deeply [$a->includes(-4, '-4:-3', -1, '0-1', 2, 3, '4-5', 6)],                     [1, 1, 1, 1, 1, 1, 0, 0];
        is_deeply [$a->includes('-04', '-04:-03', '-01', '0-01', '02', '03', '04-05', '06')], [1, 1, 1, 1, 1, 1, 0, 0];
    };
};

done_testing;
