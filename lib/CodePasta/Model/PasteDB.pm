package CodePasta::Model::PasteDB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'CodePasta::Schema',
    
    connect_info => {
        dsn => 'dbi:SQLite:pastes.db',
        user => '',
        password => '',
    }
);

=head1 NAME

CodePasta::Model::PasteDB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<CodePasta>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<CodePasta::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.59

=head1 AUTHOR

Brad Haywood

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
