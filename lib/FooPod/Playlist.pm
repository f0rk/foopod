package FooPod::Playlist;

use strict;
use warnings;
use Moose;
use FooPod::Types;

has 'children' => (
        is => 'rw',
    isa => 'Int',
);

has 'songcount' => (
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

has 'title' => (
    is => 'rw',
    isa => 'Str',
);

has 'playlistindex' => (
    is => 'rw',
    isa => 'Str',
);

has 'playlistjumptable' => (
    is => 'rw',
    isa => 'Str',
);

has 'playlistpref' => (
    is => 'rw',
    isa => 'FooPod::PlaylistPref',
);

has 'playlistdata' => (
    is => 'rw',
    isa => 'ArrayRef[FooPod::PlaylistData]',
);

1;
