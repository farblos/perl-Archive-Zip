#!/usr/bin/perl

# See https://github.com/redhotpenguin/perl-Archive-Zip/blob/master/t/README.md
# for a short documentation on the Archive::Zip test infrastructure.

use strict;

BEGIN { $^W = 1; }

use Test::More tests => 8;

use Archive::Zip qw();

use lib 't';
use common;

my $zip = Archive::Zip->new();
isa_ok($zip, 'Archive::Zip');
azok($zip->read(dataPath('jar.zip')), 'Read file');
# avoid Solaris' unzip moaning about zero-sized extra fields with
# error message "EF block length (0 bytes) invalid (< 4)"
azwok($zip, name   => 'Wrote file',
            refzip => dataPath('jar.zip'));
