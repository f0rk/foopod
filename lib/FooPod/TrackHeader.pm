package FooPod::TrackHeader;

use strict;
use warnings;
use Moose;
with 'FooPod::Entry';

has 'children' => (
    is => 'rw',
    isa => 'Int',
);

has 'trackid' => (
    is => 'rw',
    isa => 'Int',
);

has 'is_compilation' => (
    is => 'rw',
    isa => 'Bool',
);

has 'rating' => (
    is => 'rw',
    isa => 'Int',
);

has 'changetime' => (
    is => 'rw',
    isa => 'Int',
);

has 'filesize' => (
    is => 'rw',
    isa => 'Int',
);

has 'time' => (
    is => 'rw',
    isa => 'Int',
);

has 'songnum' => (
    is => 'rw',
    isa => 'Int',
);

has 'songcount' => (
    is => 'rw',
    isa => 'Int',
);

has 'year' => (
    is => 'rw',
    isa => 'Int',
);

has 'bitrate' => (
    is => 'rw',
    isa => 'Int',
);

has 'samplerate' => (
    is => 'rw',
    isa => 'Int',
);

has 'volume' => (
    is => 'rw',
    isa => 'Int',
);

has 'starttime' => (
    is => 'rw',
    isa => 'Int',
);

has 'stoptime' => (
    is => 'rw',
    isa => 'Int',
);

has 'soundcheck' => (
    is => 'rw',
    isa => 'Int',
);

has 'playcount' => (
    is => 'rw',
    isa => 'Int',
);

has 'lastplay' => (
    is => 'rw',
    isa => 'Int',
);

has 'cdnum' => (
    is => 'rw',
    isa => 'Int',
);

has 'cdcount' => (
    is => 'rw',
    isa => 'Int',
);

has 'addtime' => (
    is => 'rw',
    isa => 'Int',
);

has 'bookmark' => (
    is => 'rw',
    isa => 'Int',
);

has 'dbid1' => (
    is => 'rw',
    isa => 'Hex',
);

has 'bpm' => (
    is => 'rw',
    isa => 'Int',
);

has 'artworkcount' => (
    is => 'rw',
    isa => 'Int',
);

has 'artworksize' => (
    is => 'rw',
    isa => 'Int',
);

has 'releasedate' => (
    is => 'rw',
    isa => 'Int',
);

has 'skipcount' => (
    is => 'rw',
    isa => 'Int',
);

has 'lastskip' => (
    is => 'rw',
    isa => 'Int',
);

has 'has_artwork' => (
    is => 'rw',
    isa => 'Bool',
);

has 'has_shuffleskip' => (
    is => 'rw',
    isa => 'Bool',
);

has 'is_bookmarkable' => (
    is => 'rw',
    isa => 'Bool',
);

has 'is_podcast' => (
    is => 'rw',
    isa => 'Bool',
);

has 'dbid2' => (
    is => 'rw',
    isa => 'Hex',
);

has 'has_lyrics' => (
    is => 'rw',
    isa => 'Bool',
);

has 'is_movie' => (
    is => 'rw',
    isa => 'Bool',
);

has 'is_played' => (
    is => 'rw',
    isa => 'Bool',
);

has 'pregap' => (
    is => 'rw',
    isa => 'Int',
);

has 'samplecount' => (
    is => 'rw',
    isa => 'Hex',
);

has 'postgap' => (
    is => 'rw',
    isa => 'Int',
);

has 'mediatype' => (
    is => 'rw',
    isa => 'Int',
);

has 'seasonnum' => (
    is => 'rw',
    isa => 'Int',
);

has 'episodenum' => (
    is => 'rw',
    isa => 'Int',
);

has 'gaplessdata' => (
    is => 'rw',
    isa => 'Int',
);

has 'has_gapless' => (
    is => 'rw',
    isa => 'Bool',
);

has 'nocrossfade' => (
    is => 'rw',
    isa => 'Bool',
);

1;
