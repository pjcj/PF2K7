#!/usr/bin/env perl

use strict;
use warnings;

use feature ':5.10';

use aliased 'DBIx::Class::DeploymentHandler' => 'DH';
use FindBin;
use lib "$FindBin::Bin/../lib";
use Config::JFDI;
use PF2K7::Schema;

my $config = Config::JFDI->new( name => 'PF2K7', path => "$FindBin::Bin/../" );
my $config_hash  = $config->get();
my $connect_info = $config_hash->{'Model::PF2K7'}{connect_info};
my $schema       = PF2K7::Schema->connect($connect_info);

my $dh = DH->new({
    schema           => $schema,
    script_directory => "$FindBin::Bin/../dbicdh",
    databases        => 'PostgreSQL',
    sql_translator_args => {
        quote_table_names => q{"},
        quote_field_names => q{"},
        producer_args => {
            quote_table_names => q{"},
            quote_field_names => q{"},
        },
    },
});

sub install {
    $dh->prepare_install();
    $dh->install();
}

sub upgrade {
    die 'Please update the version in Schema.pm'
        if ( $dh->version_storage()->version_rs()->search({
                 version => $dh->schema_version(),
             })->count()
           )
        ;

    die 'We only support positive integers for versions around these parts.'
        if $dh->schema_version() !~ m{\A \d+ \z}xms;

    $dh->prepare_deploy();
    $dh->prepare_upgrade();
    $dh->upgrade();
}

sub current_version {
    say $dh->database_version();
}

sub help {
say <<'OUT';
usage:
  install
  upgrade
  current-version
OUT
}

help unless $ARGV[0];

given ( $ARGV[0] ) {
    when ('install')         { install()         }
    when ('upgrade')         { upgrade()         }
    when ('current-version') { current_version() }
}
