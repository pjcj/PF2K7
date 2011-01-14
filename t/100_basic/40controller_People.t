#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use Catalyst::Test "PF2K7";
use PF2K7::Controller::People;

# for my $url (qw( /login /register /status ))
for my $url (qw( /login /register ))
{
    ok request($url)->is_success, "Request to $url succeeded";
}

ok action_redirect("/logout"), "Request to /logout is redirect";

done_testing();
