use strict;
use warnings;
use Test::More;
use t::Util;
use Array::RangedInt;

my @case = (
    { args => ['1'], expected => ['1'] },
    { args => ['1', '2'], expected => ['1', '2'] },
    { args => ['-1'], expected => ['-1'] },
    { args => ['-1', '-2'], expected => ['-1', '-2'] },
    { args => ['-1', '-2', '2'], expected => ['-1', '-2', '2'] },

    { args => ['10-20'], expected => ['10-20'] },
    { args => ['10-20', '25-30'], expected => ['10-20', '25-30'] },
    { args => ['-10-20'], expected => ['-10-20'] },
    { args => ['-10-20', '25-30'], expected => ['-10-20', '25-30'] },

    { args => ['010-020'], expected => ['10-20'] },
    { args => ['-010-020'], expected => ['-10-20'] },
    { args => ['010-020', '025-030'], expected => ['10-20', '25-30'] },
    { args => ['-010-020', '025-030'], expected => ['-10-20', '25-30'] },
    { args => ['00010-00020', '00025-00030'], expected => ['10-20', '25-30'] },
    { args => ['-00010-00020', '00025-00030'], expected => ['-10-20', '25-30'] },

    { args => ['100-2000'], expected => ['100-2000'] },
    { args => ['010-020'], expected => ['10-20'] },
    { args => ['0100-02000'], expected => ['100-2000'] },
    { args => ['000100-0002000'], expected => ['100-2000'] },
    { args => ['-000100-0002000'], expected => ['-100-2000'] },

    { args => ['11-101'], expected => ['11-101'] },
    { args => ['0101-0010001'], expected => ['101-10001'] },
    { args => ['-8:-5', '-2:3', '5-15', '51-101'], expected => ['-8:-5', '-2:3', '5-15', '51-101'] },
);

subtest 'functional' => sub {
    for my $case ( @case ) {
        my @args = @{$case->{args}};
        my @ex   = @{$case->{expected}};
        my $name = sprintf '[%s] -> [%s]', (join ',', map "\"$_\"", @args), (join ',', map "\"$_\"", @ex);
        is_deeply [Array::RangedInt::_normalize(@args)], \@ex, $name;
    }
};

subtest 'objective' => sub {
    my $a = new();
    for my $case ( @case ) {
        my @args = @{$case->{args}};
        my @ex   = @{$case->{expected}};
        my $name = sprintf '[%s] -> [%s]', (join ',', map "\"$_\"", @args), (join ',', map "\"$_\"", @ex);
        is_deeply [$a->_normalize(@args)], \@ex, $name;
    }
};

done_testing;
