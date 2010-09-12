package FooPod::Entry;

use strict;
use warnings;
use Moose::Role;
use FooPod::Types;

# where in the file this entry is located
has 'offset' => (
    is => 'rw',
    isa => 'Int',
);

# what sort of entry this is,
# e.g. mhbd, mhod, etc.
has 'entry_type' => (
    is => 'rw',
    isa => 'Str',
);

# how large this entry is
has 'header_size' => (
    is => 'rw',
    isa => 'Int',
);

# if this entry has children,
# its total size > header size
has 'total_size' => (
    is => 'rw',
    isa => 'Int',
);

1;
