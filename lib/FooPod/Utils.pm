package FooPod::Utils;

use strict;
use warnings;
use Carp;

# read a string from the database file
sub read_string {
    my ($fh, $start, $length) = @_;

    FooPod::Utils::check_fh($fh);
    FooPod::Utils::check_int("start", $start);
    FooPod::Utils::check_int("length", $length);

    FooPod::Utils::seek($fh, $start, 0);

    my ($bytes_read, $buffer) = FooPod::Utils::read($fh, $length);

    FooPod::Utils::check_bytes_read($length, $start, $bytes_read);
    FooPod::Utils::check_read_buffer($length, $start, $buffer);

    return $buffer;
}

# read an integer from the database file
sub read_int {
    my ($fh, $start, $length) = @_;

    my $buffer = FooPod::Utils::read_string($fh, $start, $length);

    return FooPod::Utils::unpack_int($buffer);
}

# read a boolean value from the database file
sub read_bool {
    my ($fh, $start, $length) = @_;

    return FooPod::Utils::read_int($fh, $start, $length) ? 1 : 0;
}

sub read_hex {
    my ($fh, $start, $length) = @_;

    my $buffer = FooPod::Utils::read_string($fh, $start, $length);

    return unpack("H16", $buffer);
}

# unpacks an int from the given input buffer
sub unpack_int {
    my ($buffer) = @_;

    return int(unpack("V", pack("H16", unpack("H16", $buffer))));
}

# wrap the standard open call in for better
# error reporting and in case I need to replace
# open with sysopen later
sub open {
    my ($mode, $path) = @_;

    open(my $fh, $mode, $path) or Carp::croak("open of $path failed: $!");

    return $fh;
}

# wrap the standard seek call in for better
# error reporting and in case I need to replace
# seek with sysseek later
sub seek {
    my ($fh, $start, $whence) = @_;
    seek($fh, $start, $whence) or Carp::croak("seek to $start (whence $whence) failed: $!");
}

# wrap the standard tell call in for better
# error reporting and in case I need to replace
# tell with 'systell' later (yes I know that]
# isn't a real function)
sub tell {
    my ($fh) = @_;
    
    my $position = tell($fh);

    Carp::croak("tell failed: $!") if $position < 0;

    return $position;
}

# wrap the standard read call in for better
# error reporting and in case I need to replace
# read with sysread later
sub read {
    my ($fh, $length) = @_;

    my $buffer = undef;
    my $bytes_read = read($fh, $buffer, $length) or Carp::croak("read failed: $!");
    return ($bytes_read, $buffer);
}

# check if we have a valid filhandle, mostly
# for internal checks
sub check_fh {
    my ($fh) = @_;
    Carp::croak("filehandle is null") if !defined($fh);
}

# check if we have an int, mostly for internal
# checks
sub check_int {
    my ($name, $int) = @_;
    Carp::croak("$name was undefined which is definitely not an integer") if !defined($int);
    Carp::croak("$name given as $int which is not an integer") if $int !~ /^\d+$/;
}

# check to see that the correct number of bytes
# were returned from a read
sub check_bytes_read {
    my ($length, $start, $bytes_read) = @_;
    Carp::croak("tried to read $length bytes at position $start but only read $bytes_read") if $bytes_read != $length;
}

# check to make sure our buffer was actually
# populated correctly
sub check_read_buffer {
    my ($length, $start, $buffer) = @_;
    Carp::croak("tried to read $length bytes at position $start but buffer was empty") if !defined($buffer);
}

1;
