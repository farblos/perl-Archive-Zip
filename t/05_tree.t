#!/usr/bin/perl

# See https://github.com/redhotpenguin/perl-Archive-Zip/blob/master/t/README.md
# for a short documentation on the Archive::Zip test infrastructure.

use strict;

BEGIN { $^W = 1; }

use Test::More tests => 8;

use Archive::Zip qw();

use lib 't';
use common;

# Test Archive::Zip::addTree

my $zip;
my @memberNames;

sub makeZip {
    my ($src, $dest, $pred) = @_;
    $zip = Archive::Zip->new();
    $zip->addTree($src, $dest, $pred);
    @memberNames = $zip->memberNames();
}

sub makeZipAndLookFor {
    my ($src, $dest, $pred, $lookFor) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    makeZip($src, $dest, $pred);
    ok(@memberNames);
    ok((grep { $_ eq $lookFor } @memberNames) == 1)
        or diag("Can't find $lookFor in (" . join(",", @memberNames) . ")");
}

# do not zip files from below test directories, or otherwise
# their removal in parallel tests can cause race conditions in
# method Archive::Zip::addTree
makeZipAndLookFor('.', '',   sub { note "file $_";
                                   -f && ! /\btestdir\b/ && /\.t$/ },       't/02_main.t');
makeZipAndLookFor('.', 'e/', sub { -f && ! /\btestdir\b/ && /\.t$/ },       'e/t/02_main.t');
makeZipAndLookFor('t', '',   sub { -f && ! /\btestdir\b/ && /\.t$/ },       '02_main.t');
makeZipAndLookFor('t', 'e/', sub { -f && ! /\btestdir\b/ && /\.t$/ || -d }, 'e/data/');
