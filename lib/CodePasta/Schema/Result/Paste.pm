use utf8;
package CodePasta::Schema::Result::Paste;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

CodePasta::Schema::Result::Paste

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

__PACKAGE__->table("pastes");

__PACKAGE__->add_columns(
  "paste_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "id",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "code",
  { data_type => "blob", is_nullable => 0 },
  "syntax",
  { data_type => "text", is_nullable => 0 },
  "date_created",
  { data_type => "text", is_nullable => 0 },
  "karma",
  { data_type => "integer", is_nullable => 1 },
);

__PACKAGE__->set_primary_key("paste_id");

__PACKAGE__->has_many(
  "saved_pastes",
  "CodePasta::Schema::Result::SavedPaste",
  { "foreign.paste_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-05-25 11:33:03
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5nKlmfHcgXozLgF0oAKh5A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
