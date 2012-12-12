use strict;
use warnings;
use Test::More;
use t::Util;

subtest 'single' => sub {
    subtest 'vs single' => sub {
        my $a = new(-5, -2, 0, 3, 6, 8, 10, 15);

        $a->remove(1);
        is_deeply $a->{_items}, [-5, -2, 0, 3, 6, 8, 10, 15];

        $a->remove(3);
        is_deeply $a->{_items}, [-5, -2, 0, 6, 8, 10, 15];

        $a->remove(-2, 0, 2, 10);
        is_deeply $a->{_items}, [-5, 6, 8, 15];
    };

    subtest 'vs ranged' => sub {
        my $a = new(-5, -2, 0, 3, 6, 8, 10, 15);

        $a->remove('1-2');
        is_deeply $a->{_items}, [-5, -2, 0, 3, 6, 8, 10, 15];

        $a->remove('-2:3', '10:15', '-8:-5');
        is_deeply $a->{_items}, [6, 8];
    };
};

subtest 'ranged' => sub {
    subtest 'vs single' => sub {
        my $a = new('-8:-5', '-2:3', '5-15', '51-101');

        $a->remove(40);
        is_deeply $a->{_items}, ['-8--5', '-2-3', '5-15', '51-101'];

        $a->remove(-3, 0, 5, 101);
        is_deeply $a->{_items}, ['-8--5', '-2--1', '1-3', '6-15', '51-100'];
    };

    subtest 'vs ranged' => sub {
        my $a = new('-8:-5', '-2:3', '5-15', '51-101');

        $a->remove('20-40');
        is_deeply $a->{_items}, ['-8--5', '-2-3', '5-15', '51-101'];

        $a->remove('-8:-5');
        is_deeply $a->{_items}, ['-2-3', '5-15', '51-101'];

        $a->remove('40-51');
        is_deeply $a->{_items}, ['-2-3', '5-15', '52-101'];

        $a->remove('40-60');
        is_deeply $a->{_items}, ['-2-3', '5-15', '61-101'];

        $a->remove('101-120');
        is_deeply $a->{_items}, ['-2-3', '5-15', '61-100'];

        $a->remove('91-120');
        is_deeply $a->{_items}, ['-2-3', '5-15', '61-90'];

        $a->remove('3-5');
        is_deeply $a->{_items}, ['-2-2', '6-15', '61-90'];

        $a->remove('11-70');
        is_deeply $a->{_items}, ['-2-2', '6-10', '71-90'];

        $a->remove('76-85');
        is_deeply $a->{_items}, ['-2-2', '6-10', '71-75', '86-90'];

        $a->remove('-2:10');
        is_deeply $a->{_items}, ['71-75', '86-90'];

        $a->remove('50-150');
        is_deeply $a->{_items}, [];
    };
};

done_testing;
