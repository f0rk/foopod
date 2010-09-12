package FooPod::Atom;

use strict;
use warnings;
use Moose;
with 'FooPod::Entry';

has 'atom_type' => (
    is => 'rw',
    isa => 'Int',
);

has 'padding' => (
    is => 'rw',
    isa => 'Int',
);

# payload could really be anything
has 'payload' => (
    is => 'rw',
    isa => 'Str',
);

sub type_map {
    my ($int) = @_;

    my %map = (
        1 => 'title',
        2 => 'path',
        3 => 'album',
        4 => 'artist',
        5 => 'genre',
        6 => 'filedescription',
        7 => 'eq',
        8 => 'comment',
        9 => 'category',
        12 => 'composer',
        13 => 'group',
        14 => 'description',
        15 => 'podcastguid',
        16 => 'podcastrss',
        17 => 'chapterdata',
        18 => 'subtitle',
        19 => 'tvshow',
        20 => 'tvepisode',
        21 => 'tvnetwork',
        22 => 'albumartist',
        23 => 'artistthe',
        24 => 'keywords',
        27 => 'sorttitle',
        28 => 'sortalbum',
        29 => 'sortalbumartist',
        30 => 'sortcomposer',
        31 => 'sorttvshow',
    );

    return $map{$int};
}

1;
