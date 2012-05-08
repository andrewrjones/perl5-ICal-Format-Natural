#!perl

use strict;
use warnings;

use Test::More tests => 1;
use FindBin qw($Bin);

use ICal::Format::Natural qw(ical_format_natural);

use Data::ICal;

my $result;

$result = ical_format_natural('foo');
error_ok($result);

# expects $r to be an error
sub error_ok {
    my $r = shift;
    like( $r, qr/^error parsing date/, "$r is an error" );
}
