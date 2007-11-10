# $Id: /mirror/perl/GunghoX-FollowLinks/trunk/lib/GunghoX/FollowLinks.pm 8898 2007-11-10T15:36:50.079780Z daisuke  $
#
# Copyright (c) 2007 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

package GunghoX::FollowLinks;
use strict;
use warnings;
use base qw(Gungho::Component);
use Gungho::Util;
our $VERSION = '0.00001';

__PACKAGE__->mk_classdata($_) for qw(follow_links_parser);

sub setup
{
    my $c = shift;
    $c->next::method();

    my $config = $c->config->{follow_links};

    $c->follow_links_parser( {} );
    foreach my $parser_config (@{ $config->{parsers} }) {
        my $module = $parser_config->{module};
        my $pkg    = Gungho::Util::load_module($module, 'GunghoX::FollowLinks');
        my $obj    = $pkg->new( %{ $parser_config->{config} } );

        $obj->register( $c );
    }

    $c;
}

sub follow_links
{
    my ($c, $response) = @_;

    my $content_type = $response->content_type;
    my $parser =
        $c->follow_links_parsers->{ $content_type } ||
        $c->follow_links_parsers->{ 'DEFAULT' } 
    ;
    return () unless $parser;

    $parser->parse( $c, $response );
}

1;

__END__

=head1 NAME

GunghoX::FollowLinks - Automatically Follow Links Within Responses

=head1 SYNOPSIS

  follow_links:
    parsers:
      - module: HTML
        config:
          rules:
            - module: HTML::SelectedTags
              config:
                tags:
                  - a
      - module: Text
        config:
          rules:
            - module: URI
              config:
                - host: ^example\.com

=head1 DESCRIPTION

This is alpha release software. Do NOT use it in production yet!

=head1 METHODS

=head2 setup

=head2 follow_links
              
=head1 AUTHOR

Copyright (c) 2007 Daisuke Maki E<lt>daisuke@endeworks.jpE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
