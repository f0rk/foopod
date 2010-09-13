package FooPod::PlaylistData;

use strict;
use warnings;
use Moose;

has 'action' => (
    is => 'rw',
    isa => 'Int',
);

has 'field' => (
    is => 'rw',
    isa => 'Int',
);

has 'data' => (
    is => 'rw',
    isa => 'Str',
);

1;
