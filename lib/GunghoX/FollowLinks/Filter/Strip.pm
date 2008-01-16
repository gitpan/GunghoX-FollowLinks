# $Id: /mirror/perl/GunghoX-FollowLinks/trunk/lib/GunghoX/FollowLinks/Filter/Strip.pm 39011 2008-01-16T15:31:39.350176Z daisuke  $

package GunghoX::FollowLinks::Filter::Strip;
use strict;
use warnings;
use base qw(GunghoX::FollowLinks::Filter);

sub apply
{
    my ($self, $c, $uri) = @_;

    $uri->fragment(undef);
    $uri->query(undef);
}

1;