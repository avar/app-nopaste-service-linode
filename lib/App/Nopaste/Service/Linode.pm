package App::Nopaste::Service::Linode;
use strict;
use warnings;
use base 'App::Nopaste::Service::AnyPastebin';

sub uri { "http://p.linode.com" }

sub get {
    my $self = shift;
    my $mech = shift;
    my %args = @_;

    $args{username} ||= 'no';
    $args{password} ||= 'spam';
    
    return $self->SUPER::get($mech => %args);
}

sub fill_form {
    my $self = shift;
    my $mech = shift;
    my %args = @_;

    ## Everything past this point could be replaced by this if
    ## App::Nopaste::Service::AnyPastebin allowed me to customize the
    ## code2 paramater to code2z
    #$self->SUPER::fill_form($mech, %args);
    
    my $header = {
        'User-Agent' => 'Mozilla/5.0',
        'Content-Type' => 'application/x-www-form-urlencoded'
    };
    
    my $content = {
        paste => 'Send',
        code2z => $args{text},
        poster => exists($args{nick})? $args{nick} : '',
        format => exists($self->FORMATS->{$args{lang}})? $args{lang} : 'text',
        expiry => 'd'
    };
    
    $mech->agent_alias('Linux Mozilla');
    my $form = $mech->form_name('editor') || return;
    
    # do not follow redirect please
    @{$mech->requests_redirectable} = ();
    
    my $paste = HTML::Form::Input->new(
        type => 'text',
        value => 'Send',
        name => 'paste'
    )->add_to_form($form);
    
    return $mech->submit_form( form_name => 'editor', fields => $content );
}

=head1 NAME

App::Nopaste::Service::Linode - L<App::Nopaste> interface to L<http://p.linode.com>

=head1 AUTHOR

E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason <avar@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason <avar@cpan.org>

=cut

1;

