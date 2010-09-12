package FooPod::Track;

use strict;
use warnings;
use Moose;
use FooPod::Types;

has 'addtime' => (
    is => 'rw',
    isa => 'Int',
);

has 'album' => (
    is => 'rw',
    isa => 'Str',
);

has 'albumartist' => (
    is => 'rw',
    isa => 'Str',
);

has 'artist' => (
    is => 'rw',
    isa => 'Str',
);

has 'artistthe' => (
    is => 'rw',
    isa => 'Str',
);

has 'artworkcount' => (
    is => 'rw',
    isa => 'Int',
);

has 'artworksize' => (
    is => 'rw',
    isa => 'Int',
);

has 'bitrate' => (
    is => 'rw',
    isa => 'Int',
);

has 'bookmark' => (
    is => 'rw',
    isa => 'Int',
);

has 'bpm' => (
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

has 'changetime' => (
    is => 'rw',
    isa => 'Int',
);

has 'comment' => (
    is => 'rw',
    isa => 'Str',
);

has 'composer' => (
    is => 'rw',
    isa => 'Str',
);

has 'dbid1' => (
    is => 'rw',
    isa => 'Hex',
);

has 'dbid2' => (
    is => 'rw',
    isa => 'Hex',
);

has 'episodenum' => (
    is => 'rw',
    isa => 'Int',
);

has 'filedescription' => (
    is => 'rw',
    isa => 'Str',
);

has 'filesize' => (
    is => 'rw',
    isa => 'Int',
);

has 'gaplessdata' => (
    is => 'rw',
    isa => 'Int',
);

has 'genre' => (
    is => 'rw',
    isa => 'Str',
);

has 'group' => (
    is => 'rw',
    isa => 'Str',
);

has 'has_artwork' => (
    is => 'rw',
    isa => 'Bool',
);

has 'has_gapless' => (
    is => 'rw',
    isa => 'Bool',
);

has 'has_lyrics' => (
    is => 'rw',
    isa => 'Bool',
);

has 'has_shuffleskip' => (
    is => 'rw',
    isa => 'Bool',
);

has 'is_compilation' => (
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

has 'lastplay' => (
    is => 'rw',
    isa => 'Int',
);

has 'lastskip' => (
    is => 'rw',
    isa => 'Int',
);

has 'mediatype' => (
    is => 'rw',
    isa => 'Int',
);

has 'nocrossfade' => (
    is => 'rw',
    isa => 'Bool',
);

has 'path' => (
    is => 'rw',
    isa => 'Str',
);

has 'playcount' => (
    is => 'rw',
    isa => 'Int',
);

has 'postgap' => (
    is => 'rw',
    isa => 'Int',
);

has 'pregap' => (
    is => 'rw',
    isa => 'Int',
);

has 'rating' => (
    is => 'rw',
    isa => 'Int',
);

has 'releasedate' => (
    is => 'rw',
    isa => 'Int',
);

has 'samplecount' => (
    is => 'rw',
    isa => 'Hex',
);

has 'seasonnum' => (
    is => 'rw',
    isa => 'Int',
);

has 'skipcount' => (
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

has 'sortalbum' => (
    is => 'rw',
    isa => 'Str',
);

has 'sortalbumartist' => (
    is => 'rw',
    isa => 'Str',
);

has 'sortcomposer' => (
    is => 'rw',
    isa => 'Str',
);

has 'sorttitle' => (
    is => 'rw',
    isa => 'Str',
);

has 'soundcheck' => (
    is => 'rw',
    isa => 'Int',
);

has 'samplerate' => (
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

has 'subtitle' => (
    is => 'rw',
    isa => 'Str',
);

has 'time' => (
    is => 'rw',
    isa => 'Int',
);

has 'title' => (
    is => 'rw',
    isa => 'Str',
);

has 'trackid' => (
    is => 'rw',
    isa => 'Int',
);

has 'volume' => (
    is => 'rw',
    isa => 'Int',
);

1;
