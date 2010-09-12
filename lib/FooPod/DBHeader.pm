package FooPod::DBHeader;

use strict;
use warnings;
use Moose;
with 'FooPod::Entry';

# how many children this node has
has 'children' => (
    is => 'rw',
    isa => 'Int',
);

1;
