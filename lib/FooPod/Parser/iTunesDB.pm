package FooPod::Parser::iTunesDB;

use strict;
use warnings;
use Moose;
use Carp;
use Unicode::String;
use FooPod::Utils;

# low-level parse items
use FooPod::DBHeader;
use FooPod::GroupHeader;
use FooPod::FilesHeader;
use FooPod::TrackHeader;
use FooPod::Atom;
use FooPod::PlaylistHeader;
use FooPod::PlaylistMetadata;
use FooPod::PlaylistItem;

# high-level parse items
use FooPod::DB;
use FooPod::Track;
use FooPod::Playlist;

# it's a parser
with 'FooPod::Parser';

# parse is a method which takes no arguments
# and parses the file from the path given
# when the object was constructed
sub parse {
    my ($self) = @_;

    # setup the dispatch table to handle different types
    # of entries
    my %parse_dispatch = (
        mhbd => \&parse_db_header,
        mhsd => \&parse_group_header,
        mhlt => \&parse_files_header,
        mhit => \&parse_track_header,
        mhod => \&parse_atom,
        mhlp => \&parse_playlist_header,
        mhyp => \&parse_playlist_metadata,
        mhip => \&parse_playlist_item, 
    );

    my %cb_dispatch = (
        # low-level
        mhbd => $self->db_header_cb,
        mhsd => $self->group_header_cb,
        mhlt => $self->files_header_cb,
        mhit => $self->track_header_cb,
        mhod => $self->atom_cb,
        mhlp => $self->playlist_header_cb,
        mhyp => $self->playlist_metadata_cb,
        mhip => $self->playlist_item_cb,

        # high-level
        db => $self->db_cb,
        track => $self->track_cb,
        playlist => $self->playlist_cb,
    );

    my $fh = FooPod::Utils::open('<', $self->path());
    
    my $db_header = parse_db_header($fh, 0);

    $cb_dispatch{$db_header->entry_type()}($db_header) if defined($cb_dispatch{$db_header->entry_type()});

    # there will be state
    my $first_group_header = 1; # whether or not this is the first of the 'group headers'
    my $last_track = undef; # for knowing which track the mhod atoms belong to
    my $last_playlist = undef;

    my $offset = $db_header->header_size();
    while($offset < $db_header->total_size()) {
        my $entry_type = FooPod::Utils::read_string($fh, $offset, 4);

        if(!defined($parse_dispatch{$entry_type})) {
            Carp::croak("Found entry type $entry_type, which was not recognized");
        }

        # $obj could be any kind of parsed db entry
        my $obj = $parse_dispatch{$entry_type}($fh, $offset);

        # call the callback, if there is one
        $cb_dispatch{$entry_type}($obj) if defined($cb_dispatch{$entry_type});

        if($first_group_header && defined($cb_dispatch{db}) && $obj->isa('FooPod::GroupHeader')) {
            $first_group_header = 0;

            my $db = get_db_info($fh, $db_header, $obj, \%parse_dispatch);

            $cb_dispatch{db}($db);
        }

        ## TRACKS
        if(defined($last_track) && defined($cb_dispatch{track}) && !$obj->isa('FooPod::Atom')) {
            $cb_dispatch{track}($last_track);
            $last_track = undef;
        }

        # set up the last track because it could have arbitralily many atom children
        if(defined($cb_dispatch{track}) && $obj->isa('FooPod::TrackHeader')) {
            $last_track = track_from_trackheader($obj);
        }

        # if we have an atom see which parent it belongs to
        if(defined($last_track) && $obj->isa('FooPod::Atom')) {
            # set the appropriate data in the parent
            my ($type, $string) = atom_payload_as_normal($fh, $obj);
            $last_track->$type($string);
        }
        ## END TRACKS
        
        ## PLAYLISTS
        if(defined($last_playlist) && defined($cb_dispatch{playlist}) && !$obj->isa('FooPod::Atom')) {
            $cb_dispatch{playlist}($last_playlist);
            $last_playlist = undef;
        }

        if(defined($cb_dispatch{playlist}) && $obj->isa('FooPod::PlaylistHeader')) {
            #$last_playlist = playlist_from_playlistheader($obj);
        }

        if(defined($last_playlist) && $obj->isa('FooPod::PlaylistMetadata')) {
            # this could be fun...
        }

        if(defined($last_playlist) && $obj->isa('FooPod::Atom')) {
            # this is where it gets tricky...
        }
        ## END PLAYLISTS

        if(!$obj->isa('FooPod::Atom')) {
            $offset += $obj->header_size();
        } else {
            $offset += $obj->total_size();
        }
    }
}

# parse out the database header and return
# a FooPod::DBHeader object
sub parse_db_header {
    my ($fh, $offset) = @_;

    return FooPod::DBHeader->new(
        offset => $offset,
        entry_type => FooPod::Utils::read_string($fh, $offset, 4),
        header_size => FooPod::Utils::read_int($fh, $offset + 4, 4),
        total_size => FooPod::Utils::read_int($fh, $offset + 8, 4),
        children => FooPod::Utils::read_int($fh, $offset + 20, 4),
    );
}

# every iTunesDB has two of these, identified by 'mhsd'
# in the file. They are the headers that appear before
# the track and playlist sections
sub parse_group_header {
    my ($fh, $offset) = @_;

    return FooPod::GroupHeader->new(
        offset => $offset,
        entry_type => FooPod::Utils::read_string($fh, $offset, 4),
        header_size => FooPod::Utils::read_int($fh, $offset + 4, 4),
        total_size => FooPod::Utils::read_int($fh, $offset + 8, 4),
        container_type => FooPod::Utils::read_int($fh, $offset + 12, 4),
    );
}

sub parse_files_header {
    my ($fh, $offset) = @_;

    return FooPod::FilesHeader->new(
        offset => $offset,
        entry_type => FooPod::Utils::read_string($fh, $offset, 4),
        header_size => FooPod::Utils::read_int($fh, $offset + 4, 4),
        total_size => FooPod::Utils::read_int($fh, $offset + 4, 4), #same as the header size
        children => FooPod::Utils::read_int($fh, $offset + 8, 4),
    );
}

sub parse_track_header {
    my ($fh, $offset) = @_;

    my $ret = FooPod::TrackHeader->new(
        offset => $offset,
        entry_type => FooPod::Utils::read_string($fh, $offset, 4),
        header_size => FooPod::Utils::read_int($fh, $offset + 4, 4),
        total_size => FooPod::Utils::read_int($fh, $offset + 8, 4),
        children => FooPod::Utils::read_int($fh, $offset + 12, 4),
        trackid => FooPod::Utils::read_int($fh, $offset + 16, 4),
        is_compilation => FooPod::Utils::read_bool($fh, $offset + 30, 1),
        rating => FooPod::Utils::read_int($fh, $offset + 31, 1),
        changetime => FooPod::Utils::read_int($fh, $offset + 32, 4),
        filesize => FooPod::Utils::read_int($fh, $offset + 36, 4),
        time => FooPod::Utils::read_int($fh, $offset + 40, 4),
        songnum => FooPod::Utils::read_int($fh, $offset + 44, 4),
        songcount => FooPod::Utils::read_int($fh, $offset + 48, 4),
        year => FooPod::Utils::read_int($fh, $offset + 52, 4),
        bitrate => FooPod::Utils::read_int($fh, $offset + 56, 4),
        samplerate => FooPod::Utils::read_int($fh, $offset + 62, 2),
        volume => FooPod::Utils::read_int($fh, $offset + 64, 4),
        starttime => FooPod::Utils::read_int($fh, $offset + 68, 4),
        stoptime => FooPod::Utils::read_int($fh, $offset + 72, 4),
        soundcheck => FooPod::Utils::read_int($fh, $offset + 76, 4),
        playcount => FooPod::Utils::read_int($fh, $offset + 80, 4),
        lastplay => FooPod::Utils::read_int($fh, $offset + 88, 4),
        cdnum => FooPod::Utils::read_int($fh, $offset + 92, 4),
        cdcount => FooPod::Utils::read_int($fh, $offset + 96, 4),
        addtime => FooPod::Utils::read_int($fh, $offset + 104, 4),
        bookmark => FooPod::Utils::read_int($fh, $offset + 108, 4),
        dbid1 => FooPod::Utils::read_hex($fh, $offset + 112, 8),
    );

    if($ret->header_size() > 244) { # iTunes increased the header size for new features
        $ret->bpm(FooPod::Utils::read_int($fh, $offset + 122, 2));
        $ret->artworkcount(FooPod::Utils::read_int($fh, $offset + 124, 2));
        $ret->artworksize(FooPod::Utils::read_int($fh, $offset + 128, 4));
        $ret->releasedate(FooPod::Utils::read_int($fh, $offset + 140, 4));
        $ret->skipcount(FooPod::Utils::read_int($fh, $offset + 156, 4));
        $ret->lastskip(FooPod::Utils::read_int($fh, $offset + 160, 4));
        $ret->has_artwork(FooPod::Utils::read_int($fh, $offset + 164, 1) == 1);
        $ret->has_shuffleskip(FooPod::Utils::read_bool($fh, $offset + 165, 1));
        $ret->is_bookmarkable(FooPod::Utils::read_bool($fh, $offset + 166, 1));
        $ret->is_podcast(FooPod::Utils::read_bool($fh, $offset + 167, 1));
        $ret->dbid2(FooPod::Utils::read_hex($fh, $offset + 168, 8));
        $ret->has_lyrics(FooPod::Utils::read_bool($fh, $offset + 176, 1));
        $ret->is_movie(FooPod::Utils::read_bool($fh, $offset + 177, 1));
        $ret->is_played(FooPod::Utils::read_bool($fh, $offset + 178, 1));
        $ret->pregap(FooPod::Utils::read_int($fh, $offset + 184, 4));
        $ret->samplecount(FooPod::Utils::read_hex($fh, $offset + 188, 8));
        $ret->postgap(FooPod::Utils::read_int($fh, $offset + 200, 4));
        $ret->mediatype(FooPod::Utils::read_int($fh, $offset + 208, 4));
        $ret->seasonnum(FooPod::Utils::read_int($fh, $offset + 212, 4));
        $ret->episodenum(FooPod::Utils::read_int($fh, $offset + 216, 4));

        if($ret->header_size() > 356) { # iTunes increased the size again, 2007
            $ret->gaplessdata(FooPod::Utils::read_int($fh, $offset + 248, 4));
            $ret->has_gapless(FooPod::Utils::read_bool($fh, $offset + 256, 2));
            $ret->nocrossfade(FooPod::Utils::read_bool($fh, $offset + 258, 2)); #inverted in file
        }
    }

    return $ret;
}

# should this be doing more work?
sub parse_atom {
    my ($fh, $offset) = @_;

    my $ret = FooPod::Atom->new(
        offset => $offset,
        entry_type => FooPod::Utils::read_string($fh, $offset, 4),
        header_size => FooPod::Utils::read_int($fh, $offset + 4, 4),
        total_size => FooPod::Utils::read_int($fh, $offset + 8, 4),
        atom_type => FooPod::Utils::read_int($fh, $offset + 12, 2),
        padding => FooPod::Utils::read_int($fh, $offset + 15, 1),
    );

    my $start = $ret->offset() + $ret->header_size();
    my $length = $ret->offset() + $ret->total_size() - $start;

    $ret->payload(FooPod::Utils::read_string($fh, $start, $length));

    return $ret;
}

sub parse_playlist_header {
    my ($fh, $offset) = @_;

    return FooPod::PlaylistHeader->new(
        offset => $offset,
        entry_type => FooPod::Utils::read_string($fh, $offset, 4),
        header_size => FooPod::Utils::read_int($fh, $offset + 4, 4),
        total_size => FooPod::Utils::read_int($fh, $offset + 4, 4),
        children => FooPod::Utils::read_int($fh, $offset + 8, 4),
    );
}

sub parse_playlist_metadata {
    my ($fh, $offset) = @_;

    return FooPod::PlaylistMetadata->new(
        offset => $offset,
        entry_type => FooPod::Utils::read_string($fh, $offset, 4),
        header_size => FooPod::Utils::read_int($fh, $offset + 4, 4),
        total_size => FooPod::Utils::read_int($fh, $offset + 8, 4),
        children => FooPod::Utils::read_int($fh, $offset + 12, 4),
        song_count => FooPod::Utils::read_int($fh, $offset + 16, 4),
        is_masterplaylist => FooPod::Utils::read_bool($fh, $offset + 20, 1),
        playlistid => FooPod::Utils::read_hex($fh, $offset + 28, 8),
        is_playlist => FooPod::Utils::read_bool($fh, $offset + 42, 2),
    );
}

sub parse_playlist_item {
    my ($fh, $offset) = @_;

    return FooPod::PlaylistItem->new(
        offset => $offset,
        entry_type => FooPod::Utils::read_string($fh, $offset, 4),
        header_size => FooPod::Utils::read_int($fh, $offset + 4, 4),
        total_size => FooPod::Utils::read_int($fh, $offset + 8, 4),
        children => FooPod::Utils::read_int($fh, $offset + 12, 4),
        podcast_group => FooPod::Utils::read_int($fh, $offset + 16, 4),
        playlist_id => FooPod::Utils::read_int($fh, $offset + 20, 4),
        trackid => FooPod::Utils::read_int($fh, $offset + 24, 4),
        timestamp => FooPod::Utils::read_int($fh, $offset + 28, 4),
        podcast_group_ref => FooPod::Utils::read_int($fh, $offset + 32, 4),
    );
}

sub get_db_info {
    my ($fh, $db_header, $obj, $pdr) = @_;

    my %parse_dispatch = %{$pdr};

    # so we've got the $db_header object from above
    # and this is our first GroupHeader object. We
    # need to get all its sibling objects, as well 
    # as the first child (and only?) of this and the
    # other GroupHeaders so we can determine the total
    # number of songs and playlists in this library

    my $track_count = 0;
    my $playlist_count = 0;

    my $major_offset = $obj->offset();
    my $major_obj = $obj;

    while(1) {
        # get the first child
        my $child_offset = $major_offset + $major_obj->header_size();
        my $child_type = FooPod::Utils::read_string($fh, $child_offset, 4); 
        my $child_obj = $parse_dispatch{$child_type}($fh, $child_offset);

        if($child_obj->isa('FooPod::FilesHeader')) {
            $track_count += $child_obj->children();
        } elsif($child_obj->isa('FooPod::PlaylistHeader')) {
            $playlist_count += $child_obj->children();
        } else {
            Carp::croak("Unexpected child object of type ".$child_obj->entry_type());
        }

        $major_offset += $major_obj->total_size();

        if($major_offset >= $db_header->total_size()) {
            last;
        }

        my $major_type = FooPod::Utils::read_string($fh, $major_offset, 4);
        $major_obj = $parse_dispatch{$major_type}($fh, $major_offset);
    }

    my $db = FooPod::DB->new(
        filesize => $db_header->total_size(),
        songcount => $track_count,
        playlistcount => $playlist_count,
    );

    return $db;
}

sub track_from_trackheader {
    my ($track_header) = @_;

    my $ret = FooPod::Track->new(
        trackid => $track_header->trackid(),
        is_compilation => $track_header->is_compilation(),
        rating => $track_header->rating(),
        changetime => $track_header->changetime(),
        filesize => $track_header->filesize(),
        time => $track_header->time(),
        songnum => $track_header->songnum(),
        songcount => $track_header->songcount(),
        year => $track_header->year(),
        bitrate => $track_header->bitrate(),
        samplerate => $track_header->samplerate(),
        volume => $track_header->volume(),
        starttime => $track_header->starttime(),
        stoptime => $track_header->stoptime(),
        soundcheck => $track_header->soundcheck(),
        playcount => $track_header->playcount(),
        lastplay => $track_header->lastplay(),
        cdnum => $track_header->cdnum(),
        cdcount => $track_header->cdcount(),
        addtime => $track_header->addtime(),
        bookmark => $track_header->bookmark(),
        dbid1 => $track_header->dbid1(),
        bpm => $track_header->bpm(),
        artworkcount => $track_header->artworkcount(),
        artworksize => $track_header->artworksize(),
        releasedate => $track_header->releasedate(),
        skipcount => $track_header->skipcount(),
        lastskip => $track_header->lastskip(),
        has_artwork => $track_header->has_artwork(),
        has_shuffleskip => $track_header->has_shuffleskip(),
        is_bookmarkable => $track_header->is_bookmarkable(),
        is_podcast => $track_header->is_podcast(),
        dbid2 => $track_header->dbid2(),
        has_lyrics => $track_header->has_lyrics(),
        is_movie => $track_header->is_movie(),
        is_played => $track_header->is_played(),
        pregap => $track_header->pregap(),
        samplecount => $track_header->samplecount(),
        postgap => $track_header->postgap(),
        mediatype => $track_header->mediatype(),
        seasonnum => $track_header->seasonnum(),
        episodenum => $track_header->episodenum(),
        gaplessdata => $track_header->gaplessdata(),
        has_gapless => $track_header->has_gapless(),
        nocrossfade => $track_header->nocrossfade(),
    );

    return $ret;
}

sub atom_payload_as_normal {
    my ($fh, $obj) = @_; #offset points to the mhod start
    
    my $size = FooPod::Utils::read_int($fh, $obj->offset() + 28, 4);
    my $string = FooPod::Utils::read_string($fh, $obj->offset() + ($obj->total_size() - $size), $size);
    $string = Unicode::String::byteswap2($string);
    $string = Unicode::String::utf16($string)->utf8;

    my $type = FooPod::Atom::type_map($obj->atom_type());

    return ($type, $string);
}

1;
