#!/usr/bin/perl

use strict;
use warnings;
use FooPod::Parser::iTunesDB;
use File::Copy;
use File::Path;

my $mntpnt = $ARGV[0];
my $outdir = $ARGV[1];

if(!defined($mntpnt)) {
    print "No mountpoint given, exiting!\n";
    print help(), "\n";
    exit(-1);
}

if(!defined($outdir)) {
    print "No output directory given, exiting!\n";
    print help(), "\n";
    exit(-1);
}

if(!-d $mntpnt || !-r $mntpnt) {
    print "Can't find or read mountpoint, exiting!\n";
    exit(-1);
}

if(!-d $mntpnt || !-w $outdir) {
    print "Can't find or write to output directory, exiting!\n";
    exit(-1);
}

my $dbpath = "$mntpnt/iTunes_Control/iTunes/iTunesDB";

if(!-f $dbpath || !-r $dbpath) {
    print "iTunesDB not found under mountpoint, or not readable, exiting!\n";
    exit(-1);
}

my $parser = FooPod::Parser::iTunesDB->new(
    path => $dbpath,
    track_cb => sub { copy_track($outdir, $_[0]) },
);

$parser->parse();

sub copy_track {
    my ($outdir, $track) = @_; # FooPod::Track object

    my @parts = split(/:/, $track->path());
    my $filepath = "$mntpnt/$parts[1]/$parts[2]/$parts[3]/$parts[4]";
    $parts[4] =~ /\.(.+)$/;
    my $format = $1;

    if(!-f $filepath) {
        print "Oops, we can't find the song given by $track->path(), exiting!\n";
        exit(-1);
    }

    my $artist = $track->albumartist();
    $artist = $track->artist() if !defined($artist);
    if(!defined($artist)) {
        print "No artist, using 'Unknown'\n";
        $artist = 'Unknown';
    }

    my $album = $track->album();
    if(!defined($album)) {
        print "No album, using 'Unknown'\n";
        $album = 'Unknown';
    }

    my $title = $track->title();
    if(!defined($title)) {
        print "No title, using $track->trackid()\n";
        $title = $track->trackid();
    }

    $artist =~ tr!/! !;
    $album  =~ tr!/! !;
    $title =~ tr!/! !;
    my $outpath = "$outdir/$artist/$album";
    my $outfile = "$outpath/$title.$format";

    if(!-d $outpath) {
        # create dir
        make_path($outpath);
    }

    # copy file
    print "cp $filepath $outfile\n";
    copy($filepath, $outfile);
}

sub help {
    return <<EOH
usage: copy.pl MNTPNT OUTDIR
synopsis:
    Copies all songs from an iPod to a local directory,
    organized by artist/album/title.format.
parameters:
    MNTPNT: the path to the iPod's mountpoint
    OUTDIR: the path to the output directory
bugs:
    probably.
author:
    Ryan P. Kelly <rpkelly at cpan dot org>
EOH
;
}
