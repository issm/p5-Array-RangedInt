use strict;
use warnings;
use Test::More;
use t::Util;

my $a;

$a = new('-5:-3', '-1:1', 3, 5, '7-10');
is $a->stringify(), '-5--3,-1-1,3,5,7-10';
is $a->stringify(':'), '-5:-3,-1:1,3,5,7:10';
is $a->stringify('..'), '-5..-3,-1..1,3,5,7..10';

$a = new('-05:-03', '-01:01', '03', '05', '007-000010');
is $a->stringify(), '-5--3,-1-1,3,5,7-10';
is $a->stringify(':'), '-5:-3,-1:1,3,5,7:10';
is $a->stringify('..'), '-5..-3,-1..1,3,5,7..10';

done_testing;
