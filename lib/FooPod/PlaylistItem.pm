package FooPod::PlaylistItem;

use strict;
use warnings;
use Moose;
with 'FooPod::Entry';

has 'children' => (
    is => 'rw',
    isa => 'Int',
);

has 'podcast_group' => (
    is => 'rw',
    isa => 'Int',
);

has 'playlistid' => (
    is => 'rw',
    isa => 'Int',
);

has 'trackid' => (
    is => 'rw',
    isa => 'Int',
);

has 'timestamp' => (
    is => 'rw',
    isa => 'Int',
);

has 'podcast_group_ref' => (
    is => 'rw',
    isa => 'Int',
);

1;
