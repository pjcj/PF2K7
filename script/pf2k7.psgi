#!/usr/bin/env perl

use strict;
use warnings;

use Plack::Builder;

use blib;

use PF2K7;

PF2K7->setup_engine("PSGI");

my $app = sub { PF2K7->run(@_) };

builder
{
    enable "Debug",
           panels => [qw( DBITrace Memory Timer Environment Response Parameters
                          CatalystLog DBIC::QueryLog )];
    $app
}
