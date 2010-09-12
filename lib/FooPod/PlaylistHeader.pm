package FooPod::PlaylistHeader;

use strict;
use warnings;
use Moose;
with 'FooPod::Entry';

has 'children' => (
    is => 'rw',
    isa => 'Int',
);

1;
