package FooPod::DB;

use strict;
use warnings;
use Moose;

has 'filesize' => (
    is => 'rw',
    isa => 'Int',
);

has 'songcount' => (
    is => 'rw',
    isa => 'Int',
);

has 'playlistcount' => (
    is => 'rw',
    isa => 'Int',
);

1;
