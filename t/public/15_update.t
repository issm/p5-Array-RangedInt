use strict;
use warnings;
use Test::More;
use t::Util;

subtest 'format' => sub {
    my $a;
    $a = new('1-1');
    is_deeply $a->{_items}, [1];

    $a = new('5-1');
    is_deeply $a->{_items}, ['1-5'];
};

subtest 'unsorted' => sub {
    my $a;
    $a = new(-1, 5, 2, 10, 8)->update();
    is_deeply $a->{_items}, [-1, 2, 5, 8, 10], 'simple';

    $a = new('2-5', '-5:0', '11-14', '7-9', '16-20')->update();
    is_deeply $a->{_items}, ['-5-0', '2-5', '7-9', '11-14', '16-20'], 'ranged';

    $a = new(-3, '2-5', '-6:-5', 10, 8, '12-15', -8)->update();
    is_deeply $a->{_items}, [-8, '-6--5', -3, '2-5', 8, 10, '12-15'], 'mixed';
};

subtest 'resolving conflict' => sub {
    subtest '2 items' => sub {
        my $a;
        $a = new(1, 2)->update();
        is_deeply $a->{_items}, ['1-2'], 'single and single, adjacent';

        $a = new(1, 3)->update();
        is_deeply $a->{_items}, [1, 3], 'single and single, not adjacent';

        $a = new(1, '1-3')->update();
        is_deeply $a->{_items}, ['1-3'], 'single and ranged, the second includes the first';

        $a = new(2, '1-3')->update();
        is_deeply $a->{_items}, ['1-3'], 'single and ranged, the second includes the first';

        $a = new(1, '2-4')->update();
        is_deeply $a->{_items}, ['1-4'], 'single and ranged, adjacent';

        $a = new(1, '3-5')->update();
        is_deeply $a->{_items}, [1, '3-5'], 'single and ranged, not adjacent';

        $a = new('1-3', 3)->update();
        is_deeply $a->{_items}, ['1-3'], 'ranged and single, the first includes the second';

        $a = new('1-3', 2)->update();
        is_deeply $a->{_items}, ['1-3'], 'ranged and single, the first includes the second';

        $a = new('1-3', 4)->update();
        is_deeply $a->{_items}, ['1-4'], 'ranged and single, adjacent';

        $a = new('1-3', 5)->update();
        is_deeply $a->{_items}, ['1-3', 5], 'ranged and single, not adjacent';

        $a = new('-3:-1', '1:3')->update();
        is_deeply $a->{_items}, ['-3--1', '1-3'], 'ranged and ranged, not adjacent';

        $a = new('-3:0', '1:3')->update();
        is_deeply $a->{_items}, ['-3-3'], 'ranged and ranged, adjacent';

        $a = new('-3:0', '0:3')->update();
        is_deeply $a->{_items}, ['-3-3'], 'ranged and ranged, shares partially';

        $a = new('-3:1', '0:3')->update();
        is_deeply $a->{_items}, ['-3-3'], 'ranged and ranged, shares partially';

        $a = new('-3:3', '0:3')->update();
        is_deeply $a->{_items}, ['-3-3'], 'ranged and ranged, the first includes the second';

        $a = new('-3:4', '0:3')->update();
        is_deeply $a->{_items}, ['-3-4'], 'ranged and ranged, the first includes the second';
    };

    subtest 'more complicated' => sub {
        my $a;
        $a = new(1, 2, 3)->update();
        is_deeply $a->{_items}, ['1-3'];

    };
};

done_testing;
