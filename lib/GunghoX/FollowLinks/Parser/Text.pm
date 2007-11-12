# $Id: /mirror/perl/GunghoX-FollowLinks/trunk/lib/GunghoX/FollowLinks/Parser/Text.pm 8905 2007-11-11T05:32:04.269151Z daisuke  $
#
# Copyright (c) 2007 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

package GunghoX::FollowLinks::Parser::Text;
use strict;
use warnings;
use base qw(GunghoX::FollowLinks::Parser);

sub new
{
    my $class = shift;
    $class->SUPER::new( content_type => 'text/plain', @_ );
}

sub parse
{
    my ($self, $c, $response) = @_;

    my $base = $response->request->uri;
    my $content = $response->content;

    while ( $content =~ m{\b(?:[^:/?#]+:)?(?://[^/?#]*)?[^?#]*(?:\?[^#]*)?(?:#.*?))\b}gsm ) {
        my $uri = URI->new_abs( $1, $base );
        $self->follow_if_allowed( $c, $response, $uri );
    }
}

1;

__END__

=head1 NAME

GunghoX::FollowLinks::Parser::Text - Parse URLs Out Of Plain Text

=cut