package FooPod::Parser;

use strict;
use warnings;
use Moose::Role;
use Carp;

# all classes consuming this role must implement
# a 'parse' method, which will initiate the parsing
# phase
requires 'parse';

# path to the database file we will be parsing
# should be the full path, and not merely the
# mountpoint of the iPod
has 'path' => (
    is => 'ro',
    isa => 'Str',
);

## CALLBACK ATTRIBUTES
# these will be called as each different kind
# of item in the parsed file is encountered

# the database header should contain various
# pieces of information about the file database,
# such as the number of direct children of that
# header object. can be indentifid by 'mhbd' in
# the iTunesDB file.
has 'db_header_cb' => (
    is => 'ro',
    isa => 'CodeRef',
);

# what I'm calling a group header can be identified
# in an iTunesDB by 'mhsd'. There will be two of these:
# one for the tracks list, and another for the playlists
# list.
has 'group_header_cb' => (
    is => 'ro',
    isa => 'CodeRef',
);

# the files section has the header 'mhlt' (from the iTunesDB file)
has 'files_header_cb' => (
    is => 'ro',
    isa => 'CodeRef',
);

# called when encountering a track, which can be
# identified in the iTunesDB file as 'mhit'.
has 'track_header_cb' => (
    is => 'ro',
    isa => 'CodeRef',
);

# there is a generic item container which
# holds (usually) different sorts of string
# data and is used with many different kinds of
# entries. Indentified as 'mhod' in the iTunesDB file.
has 'atom_cb' => (
    is => 'ro',
    isa => 'CodeRef',
);

# every playlist has it's own header, identified by
# 'mhlp' in the iTunesDB file.
has 'playlist_header_cb' => (
    is => 'ro',
    isa => 'CodeRef',
);

# every playlist also has some associated metadata,
# especially smart playlists, which can be identified
# by 'mhyp' in the iTunesDB file.
has 'playlist_metadata_cb' => (
    is => 'ro',
    isa => 'CodeRef',
);

# playlist items themselves can be identified in the
# iTunesDB file as 'mhip'
has 'playlist_item_cb' => (
    is => 'ro',
    isa => 'CodeRef',
);

# the album group can be seen as 'mhla'
has 'album_group_cb' => (
    is => 'ro',
    isa => 'CodeRef',
);

# the album header can be seen as 'mhia'
has 'album_header_cb' => (
    is => 'ro',
    isa => 'CodeRef',
);

# this will be passed a FooPod::Track object
# for every track that is encountered
has 'track_cb' => (
    is => 'ro',
    isa => 'CodeRef',
);

# this will be passed a FooPod::Playlist object
# for every playlist that is encountered
has 'playlist_cb' => (
    is => 'ro',
    isa => 'CodeRef',
);

# this will be passed a FooPod::Album object
# for every album that is encountered
has 'album_cb' => (
    is => 'ro',
    isa => 'CodeRef',
);

1;
