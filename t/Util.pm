package t::Util;
use strict;
use warnings;
use Array::RangedInt;

my @exports = qw/
    new
    parse
/;

sub import {
    my $class = shift;
    my $caller = caller;
    for my $f ( @exports ) {
        no strict 'refs';
        *{"$caller\::$f"} = \&$f;
    }
}

sub new { Array::RangedInt->new(@_) }

sub parse { Array::RangedInt->parse(@_) }

1;
