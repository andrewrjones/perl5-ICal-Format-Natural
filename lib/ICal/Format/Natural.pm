use strict;
use warnings;

package ICal::Format::Natural;

# ABSTRACT: Create an Data::ICal object with natural parsing logic.

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(ical_format_natural);

use Data::ICal;
use DateTime::Format::Natural;

sub ical_format_natural {
    my $in = shift;

    my ( $date, $title ) = split '\.', $in;
    $date  ||= '';
    $title ||= '';
    chomp $date;
    chomp $title;

    # trim leading and trailing whitespace
    $title =~ s/^\s+|\s+$//g;

    # parse date
    my $parser = DateTime::Format::Natural->new;
    my $dt     = $parser->parse_datetime($date);

    if ( $parser->success ) {
        return 1;
    }

    return
      sprintf( "error parsing date (%s). error was: %s", $date,
        $parser->error );
}

1;
