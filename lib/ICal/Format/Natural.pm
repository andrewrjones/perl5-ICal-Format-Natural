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

=method ical_format_natural( $string )

Parses the string and returns an L<Data::ICal> object.

=cut

sub ical_format_natural {
    my $in = shift;

    my ( $date, $summary ) = split '\.', $in, 2;
    $date    ||= '';
    $summary ||= '';
    chomp $date;
    chomp $summary;

    # trim leading and trailing whitespace
    $summary =~ s/^\s+|\s+$//g;

    return 'error: no summary' unless $summary;

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

=head1 SYNOPSIS

  # only exported on demand
  use ICal::Format::Natural qw(ical_format_natural);

  my $ical = ical_format_natural('Tomorrow at noon. Lunch with Bob');
  # creates an Data::ICal object with:
  #   dtstart tomorrow 12:00
  #   dtend tomorrow 13:00
  #   summary Lunch with Bob

=head1 DESCRIPTION

C<ICal::Format::Natural> will (one day) take a human readable string and create an L<Data::ICal> object.

NOTE: Currently this is pretty dumb and simply splits the string on a fullstop, taking the first part as the date and the second part as the summary.

I would love to improve this one day, but as always it's about finding the time. Any contributions and/or ideas are most welcome.

=head1 CREDITS

Thanks to Mark Stosberg who wrote L<ICal::QuickAdd>. It contained a simple version of the parser and was the basis for this module.

=cut
