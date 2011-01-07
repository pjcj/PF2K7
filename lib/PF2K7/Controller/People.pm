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
        my $p = $c->req->params;

        if ($p->{username} && $p->{password})
        {
            if ($c->authenticate({ username => $p->{username},
                                   password => $p->{password} }))
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

{

my @enneagrams1 = qw( unknown reformer helper motivator artist thinker
                      loyalist enthusiast boss meditator );
my @enneagrams2 = ( "none", @enneagrams1 );

sub set_stash
{
    my ($self, $c) = @_;
    $c->stash(enneagrams1 => \@enneagrams1);
    $c->stash(enneagrams2 => \@enneagrams2);
}

sub validate_fields
{
    my ($self, $c, $p, $errors, $fields, @required) = @_;

    $errors->{email} =
        "Invalid email address (failed $Email::Valid::Details check)"
        unless (Email::Valid->address(-address  => $p->{email},
                                      -tldcheck => 1,
                                      -mxcheck  => 0));

    $errors->{enneagram1} = "Invalid enneagram"
        unless $p->{enneagram1} ~~ @enneagrams1;
    $errors->{enneagram2} = "Invalid enneagram"
        unless $p->{enneagram2} ~~ @enneagrams2;

    $errors->{gps} = "GPS coordinates invalid"
        if length $p->{gps} && $p->{gps} !~
            /^\s*\d+(?:\.\d+)? ?[NnSs] ?,? ?\d+(?:.\d+)? ?[EeWw]\s*$/;

    for (@required)
    {
        $errors->{$_} = "Required field" unless length $p->{$_}
    }

    if (%$errors)
    {
        $c->stash(message => "Errors found on form");
        $c->stash(errors  => $errors);
        my %values; $values{$_} = $p->{$_} for @$fields;
        $c->stash(values  => \%values);
    }

    !%$errors
}

}

sub register :Local :Args(0)
{
    my ($self, $c) = @_;

    $self->set_stash($c);

    if (lc $c->req->method eq "post")
    {
        my $p = $c->req->params;
        my $errors;
        my @fields = qw( username password name email town country motto1
                         motto2 likes dislikes gps enneagram1 enneagram2 );

        my $users_rs = $c->model("PF2K7::User");
        $errors->{username} = "Username already in use - please pick another"
            if $users_rs->find({username => $p->{username}});
        return unless
            $self->validate_fields($c, $p, \@fields,
                                   qw( username password name email town
                                       country motto1 motto2 ));

        my $newuser = $users_rs->create({ map { $_ => $p->{$_} } @fields });
        unless ($c->authenticate({ username => $p->{username},
                                   password => $p->{password} }))
        {
            $c->stash(message => "Registration failed.");
            return;
        }

        $c->stash(message => "Registration succeeded.");
        $c->go("/pf/home");
    }
}

sub status :Local :Args(0)
{
    my ($self, $c) = @_;

    $c->go("/pf/home") unless $c->user_exists;

    $self->set_stash($c);

    my @fields = qw( name email town country motto1
                     motto2 likes dislikes gps enneagram1 enneagram2 );

    my %values; $values{$_} = $c->user->get($_) for @fields;
    $values{password} = "";
    $c->stash(values => \%values);

    if (lc $c->req->method eq "post")
    {
        my $p = $c->req->params;
        my $errors;
        my $users_rs = $c->model("PF2K7::User");
        return unless
            $self->validate_fields($c, $p, \@fields,
                                   qw( name email town country motto1 motto2 ));

        # push @fields, "password" if length $p->{password};
        my $user = $c->user->obj;
        $user->update({ map { $_ => $p->{$_} } @fields });
        $c->persist_user;

        $c->stash(message => "Status updated.");
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
