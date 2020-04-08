#!/usr/bin/perl
# Time-stamp: "2008-05-19 00:43:53 ADT"   sburke@cpan.org
# desc{    get notes from just a particular track    }
#
# MIDI splitter -- for each .mid file given, writes out
#        copies of it with all notes suppressed except
#        notes on a particular channel in a particular track
#
use strict;
use MIDI;
use constant DEBUG => 1;
use constant TIMING_HACK => 1;
  # Whether to put a pianissimo dummy-event at the start of
  # the fiddled-with track, to defeat bugs in some sequencers.

die "What input files?" unless @ARGV;

my($out_basic, %tracks2channels);  # only "globals" we have

foreach my $in (@ARGV) {
  DEBUG and print "Reading $in\n";
  my $opus = MIDI::Opus->new({ 'from_file' => $in });
  print "Track count: ", scalar(@{ $opus->tracks_r }), "\n";

  $out_basic = $in;
  $out_basic =~ s/(\.midi?)$//i;

  scan_opus($opus);
  winnow_opus($opus);
  DEBUG and print "Done with $out_basic\n\n\n";
}
print "Done.  Runtime: ", time() - $^T, "s\n";


# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

sub scan_opus {
  # Builds the %tracks2channels hash-of-arrays
  my $opus = $_[0];
  %tracks2channels = ();
  my $total = 0;

  my $tracks_r = $opus->tracks_r;
  for(my $i = 0; $i < @$tracks_r; ++$i) {
    my $t = $tracks_r->[$i];
  
    my @channels;
    $#channels = 15; # preallocate the array
    foreach my $e (@{ $t->events_r || [] }) {
      #print "@$e\n";
      if($e->[0] eq 'note_on') {
        # ('note_on', dtime, channel, note, velocity)
        $channels[ $e->[2] ] = 1;
        #print "@$e\n";
      }
    }
  
    my @which = grep $channels[$_], 0 .. 15;
    $tracks2channels{ $i } = \@which if @which;
    my $count = scalar @which;
    $total += $count;
    print "Track $i used $count channels, whose numbers are: @which\n";
  }
  print "Total tracks used: $total\n";

  return;
}

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

sub winnow_opus {
  my $opus = $_[0];
  my @channelful_track_numbers = sort {$a <=> $b} keys %tracks2channels;

  die "No channels anywhere?! Aborting.\n" unless @channelful_track_numbers;
  
  DEBUG > 1 and print "Creating winnowed tracks...\n";
  my @winnowed_tracks;
  foreach my $t ($opus->tracks) {
    push @winnowed_tracks, $t->copy;
    winnow_track($winnowed_tracks[-1], -123)
  }
  DEBUG > 1 and print "Done creating ",
   scalar(@winnowed_tracks), " winnowed tracks.\n\n";
  
  foreach my $i (@channelful_track_numbers) {
    # Note that it skips over channelless ones
    foreach my $channelnum (@{ $tracks2channels{$i} }) {
      DEBUG > 1 and print "Making a copy leaving notes only in track $i channel $channelnum\n";

      my $opus = $opus->copy;
      my $tracks_r = $opus->tracks_r;
      for(my $j = 0; $j < @$tracks_r; ++$j) {
        if( $i != $j ) {
          DEBUG > 2 and print "Just dropping in winnowed track #$j\n";
          $tracks_r->[$j] = $winnowed_tracks[$j];
          next;
        }
        
        if( 1 == @{ $tracks2channels{$i} } ) {
          DEBUG > 2 and print "There are no other channels used in t\#$i (other than $channelnum)\n";
        } else {
          DEBUG > 2 and print "Actually winnowing track #$j\n";
          winnow_track( $tracks_r->[$i], $channelnum );
        }
        if( TIMING_HACK ) {
          DEBUG and print "Timing-hacking track $i\n";
          timing_hack( $tracks_r->[$i] );
        }
        
      }
      
      # Now finally write it out:
      DEBUG > 1 and print "Done winnowing.\n";
      my $outname = sprintf('%s_t%02d_c%02d.mid',
        # Output like:  whatever_t05_c01.mid, for track 5, channel 1
        $out_basic, $i, $channelnum
      );
      DEBUG and print "Writing to $outname...\n";
      $opus->write_to_file($outname);
      DEBUG > 1 and print "  ", -s $outname, " bytes\n\n";
    }
  }
  return;
}

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

sub dummy_note { ['note_on', 0, 9,51,1], ['note_off',
  0,  # change this to a 1, if the 0 just doesn't work
  9,51,0]
}

sub timing_hack {
  my $track = $_[0];
  my $eventlist = $track->events_r;
  unshift @$eventlist, dummy_note();
  push    @$eventlist, dummy_note();
  return;
}

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

sub winnow_track {
  my($track, $channel_to_keep) = @_;

  my $eventlist = $track->events_r;
  DEBUG > 1 and print "Kicking all non-channel#$channel_to_keep notes out",
   " of track $track...\n";

  my $previous;
  my $new = 0;
  my $deleted = 0;
  my $start_count = @$eventlist;
  foreach my $e (@$eventlist) {
    # Replace each note with an with an innocuous event
    DEBUG > 4 and $e->[0] ne 'sysex' and 
      print "  Considering event $e : @$e\n";
    if(
      ($e->[0] eq 'note_on' or $e->[0] eq 'note_off')
      and $e->[2] != $channel_to_keep
    ) {
      ++$deleted;
      DEBUG > 4 and print "    (Nixing.)\n";
      if($previous) {
        $previous->[1] += $e->[1];  #add our delta-time to the previous.
        @$e = ();
      } else {
        @$e = ('text_event', $e->[1], '');
        ++$new;
        $previous = $e;
      }
    } else {
      undef $previous;
    }
  }
  DEBUG > 1 and print "  ($deleted events deleted, creating $new text events; ",
    scalar(grep @$_, @$eventlist),
    " events remaining; started with $start_count)\n";
  return;
}

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

__END__

