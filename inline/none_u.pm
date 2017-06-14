
use Test::More;
use Test::LMU;

# Normal cases
my @list = ( 1 .. 10000 );
is_true( none_u  { not defined } @list );
is_true( none_u  { $_ > 10000 } @list );
is_false( none_u { defined } @list );
is_undef( none_u {} );

leak_free_ok(
    none_u => sub {
	my $ok  = none_u { $_ == 5000 } @list;
	my $ok2 = none_u { $_ == 5000 } 1 .. 10000;
    }
);
is_dying( sub { &none_u( 42, 4711 ); } );

done_testing;
