use strict;
use warnings;
use Test::More;
use t::Util;

subtest 'basic' => sub {
    my $a = new();
    isa_ok new(), 'Array::RangedInt', 'is-a Array::RangedInt';
    is_deeply $a->{_items}, [];
};

subtest 'no option' => sub {
    is_deeply new(1)->{_items}, [1];
    is_deeply new(1, 3, 5)->{_items}, [1, 3, 5];
    is_deeply new(1, 2, 3)->{_items}, ['1-3'];
};

subtest 'with option' => sub {
    is_deeply new(+{})->{_items}, [];
    is_deeply new(1, +{})->{_items}, [1];
    is_deeply new(1, 3, 5, +{})->{_items}, [1, 3, 5];
    is_deeply new(1, 2, 3, +{})->{_items}, ['1-3'];
};

subtest 'items which start with "0"' => sub {
    is_deeply new(1)->{_items}, [1];
    is_deeply new('01', '03', '05')->{_items}, [1, 3, 5];
    is_deeply new('01', '02', '03')->{_items}, ['1-3'];
};

done_testing;
