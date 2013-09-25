use strict;
use warnings;
use Test::More;
use t::Util;

subtest 'value which starts "0"' => sub {
    my $a;
    $a = new('10-20');
    is_deeply [$a->dump()], [10..20];

    $a = new('010-020');
    is_deeply [$a->dump()], [10..20];

    $a = new('010-20');
    is_deeply [$a->dump()], [10..20];

    $a = new('10-020');
    is_deeply [$a->dump()], [10..20];
};

subtest 'complex' => sub {
    my $a = new('-5:-3', '-2:1', 3, 5, '7-10');
    is_deeply [$a->dump()], [-5..-3, -2..1, 3, 5, 7..10];
};

done_testing;
