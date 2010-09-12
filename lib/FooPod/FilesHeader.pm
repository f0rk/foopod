package FooPod::FilesHeader;

use strict;
use warnings;
use Moose;
with 'FooPod::Entry';

has 'children' => (
    is => 'ro',
    isa => 'Int',
);

1;
