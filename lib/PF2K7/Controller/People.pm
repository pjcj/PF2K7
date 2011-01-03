package PF2K7::Controller::People;

use Moose;
use namespace::autoclean;

use Email::Valid;

BEGIN { extends "Catalyst::Controller" }

sub index :Path :Args(0)
{
    my ($self, $c) = @_;

    $c->response->body("Matched PF2K7::Controller::People in People.");
}

sub login :Local :Args(0)
{
    my ($self, $c) = @_;

    if (lc $c->req->method eq "post")
    {
        my $params = $c->req->params;

        if ($params->{username} && $params->{password})
        {
            if ($c->authenticate({ username => $params->{username},
                                   password => $params->{password} }))
            {
                # $c->response->redirect($c->uri_for(
                    # $c->controller('Books')->action_for('list')));
                $c->stash(message => "Welcome.");
                return;
            }
            $c->stash(message => "Login failed.");
            return;
        }

        $c->stash(message => "Empty username or password.");
    }
}

sub logout :Local :Args(0)
{
    my ($self, $c) = @_;

    $c->logout;
    $c->response->redirect($c->uri_for('/'));
}

sub register :Local :Args(0)
{
    my ($self, $c) = @_;

    if (lc $c->req->method eq "post")
    {
        my $params = $c->req->params;
        my %errors;
        my @fields = qw( username password name email town country motto1 motto2
                         likes dislikes gps enneagram1 enneagram2 );

        my $users_rs = $c->model("PF2K7::User");

        if ($users_rs->find({username => $params->{username}}))
        {
            $errors{username} = "Username already in use - please pick another";
        }

        unless (Email::Valid->address
                   (
                       -address  => $params->{email},
                       -tldcheck => 1,
                   )
               )
        {
            $errors{email} =
                "Invalid email address (failed $Email::Valid::Details check)";
        }

        for (qw( username password name email town country motto1 motto2 ))
        {
            $errors{$_} = "Required field" unless length $params->{$_}
        }

        if (%errors)
        {
            $c->stash(message => "Errors found on form");
            $c->stash(errors  => \%errors);
            my %values;
            $values{$_} = $params->{$_} for @fields;
            $c->stash(values  => \%values);

            return;
        }

        my $newuser  = $users_rs->create
        ({
            map { $_ => $params->{$_} } @fields
        });

        unless ($c->authenticate({ username => $params->{username},
                                   password => $params->{password} }))
        {
            $c->stash(message => "Registration failed.");
            return;
        }

        $c->stash(message => "Registration succeeded.");
        $c->go("/pf/home");
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

PF2K7::Controller::People - People Controller for PF2K7

=head1 DESCRIPTION

Handles authentication.

=head1 METHODS

=head1 AUTHOR

Paul Johnson, paul@pjcj.net

=head1 LICENSE

Copyright 2010, Paul Johnson (paul@pjcj.net).

This software is free.  It is licensed under the same terms as Perl itself.

=cut
