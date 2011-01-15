#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use HTTP::Request::Common qw/GET POST PUT DELETE/;
use JSON::Any;

use Catalyst::Test "PF2K7";
use PF2K7::Controller::REST;

my $j = JSON::Any->new;
my $resp;
my $req_data;

# diag "Add a resource";
$req_data = { url => "http://dev.catalystframework.org/snow_white" };
$resp = request
(
    PUT "/rest",
        "Content-Type" => "application/json",
        Content => $j->objToJson($req_data)
);
# diag $resp->status_line;
# diag $resp->content;

$req_data = { url => "http://dev.catalystframework.org" };
$resp = request
(
    PUT "/rest",
        "Content-Type" => "application/json",
        Content => $j->objToJson($req_data)
);
# diag $resp->status_line;
# diag $resp->content;

use URI::Escape;
diag "Retrieve a resource";
my $uri = uri_escape("http://dev.catalystframework.org/snow_white");
my $path = "/rest/$uri";
$resp = request( GET $path , "Content-Type" => "application/json" );
diag $resp->status_line;
diag $resp->content;

pass;

done_testing();
