#!perl

use strict;
use warnings;

use Test::More tests => 4;
use FindBin qw($Bin);

use ICal::Format::Natural qw(ical_format_natural);

use Data::ICal;
use DateTime::Format::ICal;

my $result;

$result = ical_format_natural('foo');
like( $result, qr/^error parsing date/, "$result is an error" );

$result = ical_format_natural('Mar 31 1976 at 12:34. Lunch with Bob');
isa_ok( $result, 'Data::ICal' );
is( @{ $result->entries }[0]->property('summary')->[0]->value,
    'Lunch with Bob' );
my $time = DateTime::Format::ICal->parse_datetime(
    @{ $result->entries }[0]->property('dtstart')->[0]->value );
is( $time->datetime, '1976-03-31T12:34:00' );
