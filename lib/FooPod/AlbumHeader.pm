package FooPod::AlbumHeader;

use strict;
use warnings;
use Moose;
with 'FooPod::Entry';

has 'children' => (
    is => 'rw',
    isa => 'Int',
);

has 'albumid' => (
    is => 'rw',
    isa => 'Int',
);

has 'dbid1' => (
    is => 'rw',
    isa => 'Hex',
);

1;
