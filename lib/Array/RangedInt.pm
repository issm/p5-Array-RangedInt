package Array::RangedInt;
use 5.008;
use strict;
use warnings FATAL => 'all';

our $VERSION = '0.00_01';

my $_re = qr/([+-]?\d+)(?:[-:]([+-]?\d+))?/;
my $re = qr/^${_re}$/;

sub new {
    my ($class, @args) = @_;
    my $opts = +{};
    if ( @args > 0 && ref($args[-1]) eq 'HASH' ) {
        $opts = pop @args;
    }
    my $self = bless +{
        _items => \@args,
    }, $class;
    $self->update();
    return $self;
}

sub parse {
    my ($class, $text, $opts) = @_;
    my $re_parse = qr/(?:^(?:${_re},)*${_re}$|^$)/;
    $text =~ s/ +//g;
    $text =~ s/\+//g;
    if ( $text !~ $re_parse ) { die 'invalid format' }
    my @a = split /,/, $text;
    return $class->new(@a);
}

sub add {
    my ($self, @args) = @_;
    my $items = $self->{_items};
    while ( defined( my $v = CORE::shift @args ) ) {
        push @$items, $v;
    }
    return $self->update();
}

sub remove {
    my ($self, @args) = @_;
    my @items_up = @{$self->{_items}};
    my @items_tmp;
 FOR_ARGS:
    while ( defined( my $a = CORE::shift @args ) ) {
        my ($a1, $a2) = $a =~ $re;
        ### $a: single
        if ( ! defined $a2 ) {
            while ( defined( my $i = CORE::shift @items_up ) ) {
                my ($i1, $i2) = $i =~ $re;
                ### $i: single
                if ( ! defined $i2 ) {
                    CORE::push @items_tmp, $i  if $a != $i;
                }
                ### $i: ranged
                else {
                    if ( $a < $i1  ||  $i2 < $a ) { CORE::push @items_tmp, $i }
                    elsif ( $a == $i1 ) { CORE::push @items_tmp, "@{[$a + 1]}-$i2" }
                    elsif ( $a == $i2 ) { CORE::push @items_tmp, "$i1-@{[$a - 1]}" }
                    else {
                        CORE::push @items_tmp, "$i1\-@{[$a - 1]}", "@{[$a + 1]}-$i2";
                    }
                }
            }
        }
        ### $a: ranged
        else {
            while ( defined( my $i = CORE::shift @items_up ) ) {
                my ($i1, $i2) = $i =~ $re;
                ### $i: single
                if ( ! defined $i2 ) {
                    if ( $i < $a1  ||  $a2 < $i ) { CORE::push @items_tmp, $i }
                }
                ### $i: ranged
                else {
                    if ( $i1 <= $a1  &&  $a2 <= $i2 ) {
                        if ( $i1 < $a1  &&  $a2 < $i2 ) {
                            CORE::push @items_tmp, "$i1\-@{[$a1 - 1]}", "@{[$a2 + 1]}-$i2";
                        }
                        elsif ( $i1 == $a1  &&  $i2 == $a2 ) {}
                        elsif ( $i1 == $a1 ) { CORE::push @items_tmp, "@{[$a2 + 1]}-$i2" }
                        elsif ( $i2 == $a2 ) { CORE::push @items_tmp, "$i1\-@{[$a1 - 1]}" }
                        else { }  # no case
                    }
                    elsif ( $a1 < $i1  &&  $i1 <= $a2  &&  $a2 <= $i2 ) {
                        if ( $a2 < $i2 ) { CORE::push @items_tmp, "@{[$a2 + 1]}-$i2" }
                    }
                    elsif ( $i1 <= $a1  &&  $a1 <= $i2  &&  $i2 < $a2 ) {
                        if ( $i1 < $a1 ) { CORE::push @items_tmp, "$i1\-@{[$a1 - 1]}" }
                    }
                    elsif ( $a1 < $i1  &&  $i2 < $a2 ) {}
                    else {
                        CORE::push @items_tmp, $i;
                    }
                }
            }
        }
        @items_up = @items_tmp;
        @items_tmp = ();
    }
    $self->{_items} = \@items_up;
    return $self->update();
}

sub pop {
    my ($self) = @_;
    my $v = CORE::pop @{$self->{_items}};
    my ($v1, $v2) = $self->_pop($v);
    CORE::push @{$self->{_items}}, $v2  if defined $v2;
    return $v1;
}

sub shift {
    my ($self) = @_;
    my $v = CORE::shift @{$self->{_items}};
    my ($v1, $v2) = $self->_shift($v);
    CORE::unshift @{$self->{_items}}, $v2  if defined $v2;
    return $v1;
}

sub update {
    my ($self) = @_;
    my $items = $self->{_items};

    ### check format, sort
    @$items = sort {
        my ($va, undef, $vb, undef) = ($a =~ $re, $b =~ $re);
        $va <=> $vb;
    } map {
        (my $i = $_) =~ s/:/-/g;
        my ($i1, $i2) = $i =~ $re;
        if ( ! defined $i2  ||  $i1 == $i2 ) { $i1 }
        elsif ( $i1 > $i2 )                  { "$i2\-$i1" }
        else                                 { $i }
    } @$items;

    ### resolve conflicts
    my @items_up;
    while ( defined( my $v1 = CORE::shift @$items ) ) {
        my $v0 = CORE::pop @items_up;  # last of @items_up
        if ( ! defined $v0 ) {
            CORE::push @items_up, $v1;
        }
        else {
            my ($v01, $v02) = $v0 =~ $re;
            my ($v11, $v12) = $v1 =~ $re;
            ### $v0: single, $v1: single
            if ( ! defined $v02  &&  ! defined $v12 ) {
                if ( $v01 == $v11 )        { CORE::push @items_up, $v0 }
                elsif ( $v01 + 1 == $v11 ) { CORE::push @items_up, "$v0\-$v11" }
                else                       { CORE::push @items_up, $v0, $v1 }
            }
            ### $v0: single, $v1: ranged
            elsif ( ! defined $v02  &&  defined $v12 ) {
                if ( $v11 - 1 <= $v0  &&  $v0 <= $v12) { CORE::push @items_up, "$v0\-$v12" }
                else                                   { CORE::push @items_up, $v0, $v1 }
            }
            ### $v0: ranged, $v1: single
            elsif ( defined $v02  &&  ! defined $v12 ) {
                if ( $v01 <= $v1  &&  $v1 <= $v02 )  { CORE::push @items_up, $v0 }
                elsif ( $v02 + 1 == $v1 )            { CORE::push @items_up, "$v01\-$v1" }
                else                                 { CORE::push @items_up, $v0, $v1 }
            }
            ### $v0: ranged, $v1: ranged
            else {
                if ( $v02 + 1 < $v11 )                       { CORE::push @items_up, $v0, $v1 }
                elsif ( $v11 - 1 <= $v02  &&  $v02 <= $v12 ) { CORE::push @items_up, "$v01\-$v12" }
                elsif ( $v12 <= $v02 )                       { CORE::push @items_up, $v0 }
                else                                         { CORE::push @items_up, $v0, $1 }  # no case
            }
        }
    }

    $self->{_items} = \@items_up;
    return $self;
}

sub includes {
    my ($self, @args) = @_;
    my @ret;
    my $items = $self->{_items};
 FOR_ARGS:
    while ( defined( my $v = CORE::shift @args ) ) {
        my ($v1, $v2) = $v =~ $re;
        ### $v: single
        if ( ! defined $v2 ) {
            for my $i ( @$items ) {
                my ($i1, $i2) = $i =~ $re;
                ### $i: single
                if ( ! defined $i2 ) {
                    if ( $i == $v ) { (CORE::push @ret, 1)  &&  next FOR_ARGS }
                }
                ### $i: ranged
                else {
                    if ( $i1 <= $v && $v <= $i2 ) { (CORE::push @ret, 1)  &&  next FOR_ARGS }
                }
            }
            (CORE::push @ret, 0)  &&  next FOR_ARGS;
        }
        ### $v: ranged
        else {
            my $in = 1;
            for ( my $_v = $v1; $_v <= $v2; $_v++ ) {
                $in &= $self->includes($_v);
            }
            (CORE::push @ret, $in)  &&  next FOR_ARGS;
        }
    }
    return wantarray ? @ret : $ret[0];
}

sub size {
    my ($self) = @_;
    my $ret = 0;
    for ( @{$self->{_items}} ) {
        my ($i1, $i2) = /$re/;
        if ( ! defined $i2 ) { $ret++ }
        else                 { $ret += $i2 - $i1 + 1 }
    }
    return $ret;
}

sub stringify {
    my ($self, $delim) = @_;
    $delim = '-'  if ! defined $delim;
    my $ret = join ',', @{$self->{_items}};
    $ret =~ s/([+-]?\d+)[-:]([+-]?\d+)/${1}${delim}${2}/g;
    return $ret;
}

sub dump {
    my ($self) = @_;
    return wantarray ? eval $self->stringify('..') : [eval $self->stringify('..')];
}

sub _push {
    my ($self, $a, $v) = @_;
}

sub _pop {
    my ($self, $v) = @_;
    return ()  if ! defined $v;
    $v =~ $re;
    if ( ! defined $2 )    { return ($v) }
    elsif ( $1 == $2 - 1 ) { return ($2, $1) }
    else                   { return ($2, "$1-@{[$2 - 1]}") }
}

sub _shift {
    my ($self, $v) = @_;
    return ()  if ! defined $v;
    $v =~ $re;
    if ( ! defined $2 )    { return ($v) }
    elsif ( $1 + 1 == $2 ) { return ($1, $2) }
    else                   { return ($1, "@{[$1 + 1]}-$2") }
}

sub _unshift {
    my ($self, $a, $v) = @_;
}

1;
__END__

=head1 NAME

Array::RangedInt - Array of range-described int

=head1 SYNOPSIS

  use Array::RangedInt;

  my $ari = Array::RangedInt->new( 1, 2, 3, '5-10', '11-15', '25-30' );
  # or
  my $ari = Array::RangedInt->parse( '1, 2, 3, 5-10, 11-15, 25-30' );

  print $ari->size();           # 25

  print $ari->stringify();      # 1-3,5-15,25-35
  print $ari->stringify('..');  # 1..3,5..15,25..35

  my @arr = $ari->dump();       # (1..3, 5..15, 25..35)

  $ari->add(4, '21-24');
  print $ari->stringify();  # 1-15,21-35

  $ari->remove(3, 8, '26-30');
  print $ari->stringify();  # 1-2,4-7,9-10,21-25,31-35

  print $ari->shift();      # 1
  print $ari->stringify();  # 2,4-7,9-10,21-25,31-35

  print $ari->pop();        # 35
  print $ari->stringify();  # 2,4-7,9-10,21-25,31-34

=head1 DESCRIPTION

Array::RangedInt is

=head1 METHODS

=head2 Array::RangedInt->new(@args) : Array::RangedInt

=head2 Array::RangedInt->parse($text) : Array::RangedInt

=head2 $ari->add(@args) : Array::RangedInt

=head2 $ari->remove(@args) : Array::RangedInt

=head2 $ari->shift() : Int

=head2 $ari->pop() : Int

=head2 $ari->update() : Array::RangedInt

=head2 $ari->includes(@args) : Bool|Array[Bool]

=head2 $ari->size() : Int

=head2 $ari->stringify() : Str

=head2 $ari->dump() : Array|ArrayRef

=head1 AUTHOR

IWATA, Susumu, C<< <issmxx at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-array-rangedint at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Array-RangedInt>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Array::RangedInt


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Array-RangedInt>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Array-RangedInt>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Array-RangedInt>

=item * Search CPAN

L<http://search.cpan.org/dist/Array-RangedInt/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 IWATA, Susumu.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=cut
