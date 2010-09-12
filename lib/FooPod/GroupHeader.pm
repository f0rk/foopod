package FooPod::GroupHeader;

use strict;
use warnings;
use Moose;
with 'FooPod::Entry';

# 1 is song
# 2 is playlist
has 'container_type' => (
    is => 'rw',
    isa => 'Int',
);

has 'children' => (
    is => 'rw',
    isa => 'Int',
    default => 1,
    init_arg => undef,
);

1;
