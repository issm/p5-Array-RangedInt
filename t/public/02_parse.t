use strict;
use warnings;
use Test::More;
use t::Util;

subtest 'ng' => sub {
    for my $text (
        'a',
        'a,b,c,d,e',
        '1:2:3:4:5',
        '1,2,3,d,5',
    ) {
        eval { parse($text) };
        like $@, qr/^invalid format/, qq{parse('$text') fails.};
    }
};

subtest 'ok' => sub {
    my $a;

    $a = parse('');
    isa_ok $a, 'Array::RangedInt', q{parse('')};
    is_deeply $a->{_items}, [];

    $a = parse('12345');
    isa_ok $a, 'Array::RangedInt', q{parse('12345')};
    is_deeply $a->{_items}, [12345];

    $a = parse('1,2,3,4,5');
    isa_ok $a, 'Array::RangedInt', q{parse('1,2,3,4,5')};
    is_deeply $a->{_items}, ['1-5'];

    $a = parse('1, 2, 3, 4, 5');
    isa_ok $a, 'Array::RangedInt', q{parse('1, 2, 3, 4, 5')};
    is_deeply $a->{_items}, ['1-5'];

    $a = parse('+1,+2,+3,+4,+5');
    isa_ok $a, 'Array::RangedInt', q{parse('+1,+2,+3,+4,+5')};
    is_deeply $a->{_items}, ['1-5'];

    $a = parse('-1,-2,-3,-4,-5');
    isa_ok $a, 'Array::RangedInt', q{parse('-1,-2,-3,-4,-5')};
    is_deeply $a->{_items}, ['-5--1'];

    $a = parse('1-3,4-6,8-10');
    isa_ok $a, 'Array::RangedInt', q{parse('1-3,4-6,8-10')};
    is_deeply $a->{_items}, ['1-6', '8-10'];

    $a = parse('-5--3,-2:0,1-3');
    isa_ok $a, 'Array::RangedInt', q{parse('-5--3,-2:0,1-3')};
    is_deeply $a->{_items}, ['-5-3'];

    $a = parse('-5:-3, -2, 0, 1-3');
    isa_ok $a, 'Array::RangedInt', q{parse('-5:-3, -2, 0, 1-3')};
    is_deeply $a->{_items}, ['-5--2', '0-3'];


};

subtest 'items which start with "0"' => sub {
    $a = parse('0012345');
    isa_ok $a, 'Array::RangedInt', q{parse('0012345')};
    is_deeply $a->{_items}, [12345];

    $a = parse('01-03,04-06,08-010');
    isa_ok $a, 'Array::RangedInt', q{parse('01-03,04-06,08-010')};
    is_deeply $a->{_items}, ['1-6', '8-10'];

    $a = parse('-005--03,-2:000,01-003');
    isa_ok $a, 'Array::RangedInt', q{parse('-005--03,-2:000,01-003')};
    is_deeply $a->{_items}, ['-5-3'];
};


done_testing;
