#!perl -T
use 5.008;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Array::RangedInt' ) || print "Bail out!\n";
}

diag( "Testing Array::RangedInt $Array::RangedInt::VERSION, Perl $], $^X" );
