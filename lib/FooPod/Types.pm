package FooPod::Types;

use strict;
use warnings;
use Moose::Util::TypeConstraints;

subtype 'Hex'
    => as 'Str'
    => where { /^[a-f0-9]+$/i };

1;
