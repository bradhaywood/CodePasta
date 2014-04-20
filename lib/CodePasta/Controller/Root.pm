package CodePasta::Controller::Root;
use Moose;
use DateTime;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

sub auto :Private {
    my ($self, $c) = @_;
    my $paste_rs = $c->model('PasteDB::Paste');
    my $recent = $paste_rs->search(undef, {
        order_by => { -desc => 'paste_id' },
        rows => 10
    });
   
    if ($recent->count > 0) { 
        $c->stash(recent_pastes => [ $recent->all ]);
    }
    
    $c->stash(syntax_rs => [ $c->model('PasteDB::Syntax')->all ]);
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash(title => "New Paste");

    if ($c->req->body_params->{submit}) {
        my $name   = $c->req->body_params->{title};
        my $syntax = $c->req->body_params->{syntax};
        my $code   = $c->req->body_params->{code};
        if ($name and $syntax and $code) {
            my $id;
            my @chars = ('a'..'z', '0'..'9', 'A'..'Z');
            $id .= $chars[rand($#chars)] for (0..8);
            my $uri = $c->req->base . "${id}";
            my $dt  = DateTime->now;
            $c->model('PasteDB::Paste')->create({
                id           => $id,
                name         => $name,
                code         => $code,
                syntax       => $syntax,
                date_created => $dt->dmy('/') . ' ' . $dt->hms(':')
            });
            my $redirect_uri = "/${id}";
            $c->flash->{status_msg} = "Created new paste <strong>${uri}</strong>";
            $c->res->redirect($redirect_uri);
            $c->detach;
        }
    }
    elsif ($c->req->body_params->{update}) {
        my $name   = $c->req->body_params->{title};
        my $syntax = $c->req->body_params->{syntax};
        my $code   = $c->req->body_params->{code};
        if ($name and $syntax and $code) {
            if (my $paste = $c->model('PasteDB::Paste')->find({ id => $c->req->body_params->{pid} })) {
                $paste->update({
                    code => $code
                });
                
                $c->flash->{status_msg} = "<strong>${name}</strong> was successfully updated";
                $c->res->redirect($c->uri_for("/" . $paste->id));
                $c->detach;
            }
        }
    }
}

sub search :Local :Args(0) {
    my ($self, $c) = @_;

    if ($c->req->query_params->{q}) {
        my $query     = $c->req->query_params->{q};
        $query        = lc $query;
        my $result_rs = $c->model('PasteDB::Paste')->search({ 'LOWER(me.name)' => { like => "%${query}%" } });
        $c->stash->{results} = $result_rs if $result_rs->count > 0;
        $c->stash->{title}   = "Search results";
    }
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    my $id       = $c->req->path;
    if (my $paste = $c->model('PasteDB::Paste')->find({ id => $id })) {
        $c->stash(
            paste => $paste,
            title => $paste->name
        );
    } 

    $c->stash->{template} = 'index.html';
}

sub pastes_json :Local :Args(0) {
    my ($self, $c) = @_;

    my @json;
    my $paste_rs = $c->model('PasteDB::Paste');
    while(my $p = $paste_rs->next) {
        push @json, $p->name;
    }

    $c->stash->{json} = \@json;
    $c->detach('View::JSON');
}

sub raw :Local :Args(1) {
    my ($self, $c, $id) = @_;
    if (my $paste = $c->model('PasteDB::Paste')->find({ id => $id })) {
        $c->res->content_type("text/plain");
        $c->res->body($paste->code);
        $c->detach;
    }
}

sub _post :Local :Args(0) {
    my ($self, $c) = @_;
    if ($c->req->body_params) {
        my $name   = $c->req->body_params->{title};
        my $syntax = $c->req->body_params->{syntax};
        my $code   = $c->req->body_params->{code};
        if ($name and $syntax and $code) {
            my $id;
            my @chars = ('a'..'z', '0'..'9', 'A'..'Z');
            $id .= $chars[rand($#chars)] for (0..8);
            my $uri = $c->req->base . "${id}";
            my $dt  = DateTime->now;
            $c->model('PasteDB::Paste')->create({
                id           => $id,
                name         => $name,
                code         => $code,
                syntax       => $syntax,
                date_created => $dt->dmy('/') . ' ' . $dt->hms(':')
            });
            
            my $str = "URL: ${uri}\n";
              $str .= "Raw: " . $c->req->base . "raw/${id}";
            $c->res->body($str);
            $c->detach;
        }
    }
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Brad Haywood

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
