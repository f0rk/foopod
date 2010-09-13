package FooPod::AlbumHeader;

use strict;
use warnings;
use Moose;
use FooPod::Types;

has 'albumid' => (
    is => 'rw',
    isa => 'Int',
);

has 'dbid1' => (
    is => 'rw',
    isa => 'Hex',
);

has 'album' => (
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

1;
