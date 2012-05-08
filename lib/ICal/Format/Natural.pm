use strict;
use warnings;

package ICal::Format::Natural;

# ABSTRACT: Create an Data::ICal object with natural parsing logic.

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(ical_format_natural);

use Data::ICal;
use Data::ICal::Entry::Event;
use DateTime::Format::Natural;
use DateTime::Format::ICal;

sub ical_format_natural {
    my $in = shift;

    my ( $date, $summary ) = split '\.', $in;
    $date    ||= '';
    $summary ||= '';
    chomp $date;
    chomp $summary;

    # trim leading and trailing whitespace
    $summary =~ s/^\s+|\s+$//g;

    # parse date
    my $parser = DateTime::Format::Natural->new;
    my $dt     = $parser->parse_datetime($date);

    if ( $parser->success ) {
        my $calendar = Data::ICal->new;

        my $vevent = Data::ICal::Entry::Event->new;
        $vevent->add_properties(
            summary => $summary,
            dtstart => DateTime::Format::ICal->format_datetime($dt),
            dtend =>
              DateTime::Format::ICal->format_datetime( $dt->add( hours => 1 ) ),
        );
        $calendar->add_entry($vevent);
        $calendar->add_properties( method => 'PUBLISH' );

        return $calendar;
    }

    return
      sprintf( "error parsing date (%s). error was: %s", $date,
        $parser->error );
}

1;
