package FooPod::PlaylistMetadata;

use strict;
use warnings;
use Moose;
with 'FooPod::Entry';

has 'children' => (
    is => 'rw',
    isa => 'Int',
);

has 'song_count' => (
    is => 'rw',
    isa => 'Int',
);

has 'is_masterplaylist' => (
    is => 'rw',
    isa => 'Bool',
);

has 'playlistid' => (
    is => 'rw',
    isa => 'Hex',
);

has 'is_podcast' => (
    is => 'rw',
    isa => 'Bool',
);

1;
