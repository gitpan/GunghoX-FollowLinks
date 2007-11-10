# $Id: /mirror/perl/GunghoX-FollowLinks/trunk/lib/GunghoX/FollowLinks/Parser/HTML.pm 8893 2007-11-10T14:30:51.466577Z daisuke  $
#
# Copyright (c) 2007 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

package GunghoX::FollowLinks::Parser::HTML;
use strict;
use warnings;
use base qw(GunghoX::FollowLinks::Parser);
use HTML::Parser;
use HTML::Tagset;
use URI;

__PACKAGE__->mk_accessors($_) for qw(parser);

sub new 
{
    my $class = shift;
    my $parser = HTML::Parser->new(
        start_h     => [ \&_start, "self,tagname,attr" ],
        report_tags => [ keys %HTML::Tagset::linkElements ],
    );
    return $class->next::method(@_, parser => $parser);
}

sub _start
{
    my ($self, $tag, $attr) = @_;

    my $links = $HTML::Tagset::linkElements{ $tag };
    $links = [ $links ] unless ref $links;

    my $container = $self->{ 'container' };
    my $c         = $self->{ 'context' };
    my $response  = $self->{ 'response' };
    my $base      = $self->{ 'response' }->request->uri;
    foreach my $link_attr (@$links) {
        next unless exists $attr->{ $link_attr };

        my $url = URI->new_abs( $attr->{ $link_attr }, $base );
        $container->follow_if_allowed( $c, $response, $url, { tag => $tag, attr => $attr } );
    }
}

sub parse
{
    my ($self, $c, $response) = @_;

    my $parser = $self->parser;
    local $parser->{ 'response' }  = $response;
    local $parser->{ 'container' } = $self;
    local $parser->{ 'context'  }  = $c;
    $parser->parse( $response->content );
    $parser->eof;
}

1;

__END__

=head1 NAME

GunghoX::FollowLinks::Parser::HTML - FollowLinks Parser For HTML Documents

=head1 METHODS

=head2 new

=head2 parse

=cut