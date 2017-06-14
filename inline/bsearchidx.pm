
use Test::More;
use Test::LMU;

my @list = my @in = 1 .. 1000;
for my $i ( 0 .. $#in )
{
    is( $i, bsearchidx { $_ - $in[$i] } @list );
}
my @out = ( -10 .. 0, 1001 .. 1011 );
for my $elem (@out)
{
    my $r = bsearchidx { $_ - $elem } @list;
    is( -1, $r );
}

leak_free_ok(
    bsearch => sub {
	my $elem = int( rand(1000) ) + 1;
	bsearchidx { $_ - $elem } @list;
    }
);

leak_free_ok(
    'bsearch with stack-growing' => sub {
	my $elem = int( rand(1000) );
	bsearchidx { grow_stack(); $_ - $elem } @list;
    }
);

leak_free_ok(
    'bsearch with stack-growing and exception' => sub {
	my $elem = int( rand(1000) );
	eval {
	    bsearchidx { grow_stack(); $_ - $elem or die "Goal!"; $_ - $elem } @list;
	};
    }
);
is_dying( sub { &bsearchidx( 42, ( 1 .. 100 ) ); } );

done_testing;