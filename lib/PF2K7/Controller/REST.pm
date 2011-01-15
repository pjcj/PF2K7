package PF2K7::Controller::REST;

use Moose;
use namespace::autoclean;

BEGIN { extends "Catalyst::Controller::REST" }

sub index :Path :Args(0) :ActionClass("REST")
{
    my ($self, $c) = @_;
}

sub record :Path :Args(0) :ActionClass("REST")
{
    my ($self, $c) = @_;
}

sub index_PUT
{
    my ($self, $c) = @_;

    my $url = $c->req->data->{url};

    $c->log->debug("put url [$url]");

    $self->status_created
    (
        $c,
        location => $c->req->uri->as_string,
        entity => { $url => "[[[-$url-]]]" }
    );

    return;

    my $model = $c->model('Calais');
    my $data;
    eval { $data = $model->url_as_data($url) };
    if (! $@ ) {
        $model->storage->{$url} = $data;
        $self->status_created($c,
            location => $c->req->uri->as_string,
            entity => { $url => $data } );
    }
    else { # there was an error with the web service
        $c->res->status(502);
        $c->stash( rest => {
                error =>
                'Error with the upstream web service, please retry shortly'
            } );
    }
}

*record_PUT = *index_PUT;

sub record_GET
{
    my ($self, $c, $uri) = @_;

    $c->log->debug("get uri [$uri]");

    $self->status_ok
    (
        $c,
        entity => { $uri => "{{{-$uri-}}}" }
    );

    return;

    my $model = $c->model('Calais');
    # see how $uri is automatically unescaped by Catalyst.
    if (exists $model->storage->{$uri})
    {
        $self->status_ok( $c,
            entity => { $uri => $model->storage->{$uri} },
        );
    }
    else {
        $self->status_not_found($c, {message => "$uri is not in the database"});
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

PF2K7::Controller::REST - REST Controller for PF2K7

=head1 DESCRIPTION

Main REST controller

=head1 METHODS

=head1 AUTHOR

Paul Johnson, paul@pjcj.net

=head1 LICENSE

Copyright 2010, Paul Johnson (paul@pjcj.net).

This software is free.  It is licensed under the same terms as Perl itself.

=cut
