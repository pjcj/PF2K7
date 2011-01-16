package PF2K7::Schema::Result::UsersToRole;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn");

=head1 NAME

PF2K7::Schema::Result::UsersToRole

=cut

__PACKAGE__->table("users_to_roles");

=head1 ACCESSORS

=head2 user

  data_type: 'int'
  is_foreign_key: 1
  is_nullable: 0
  size: 11

=head2 role

  data_type: 'int'
  is_foreign_key: 1
  is_nullable: 0
  size: 11

=cut

__PACKAGE__->add_columns(
  "user",
  { data_type => "int", is_foreign_key => 1, is_nullable => 0, size => 11 },
  "role",
  { data_type => "int", is_foreign_key => 1, is_nullable => 0, size => 11 },
);
__PACKAGE__->set_primary_key("user", "role");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<PF2K7::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "PF2K7::Schema::Result::Role",
  { id => "role" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 user

Type: belongs_to

Related object: L<PF2K7::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "PF2K7::Schema::Result::User",
  { id => "user" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

1;
