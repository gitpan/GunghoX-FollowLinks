# $Id: /mirror/perl/GunghoX-FollowLinks/trunk/lib/GunghoX/FollowLinks/Rule/URI.pm 8897 2007-11-10T15:34:45.758392Z daisuke  $
#
# Copyright (c) 2007 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

package GunghoX::FollowLinks::Rule::URI;
use strict;
use warnings;
use base qw(GunghoX::FollowLinks::Rule);
use URI::Match;

__PACKAGE__->mk_accessors($_) for qw(match);

sub apply
{
    my ($self, $c, $response, $url, $attrs) = @_;

    my $match = $self->match;
    foreach my $m (@$match) {
        my %m = %$m;
        my $action = delete $m{action};
        if ($url->match_parts(%m)) {
            return $action;
        }
    }
    return &GunghoX::FollowLinks::Rule::FOLLOW_DEFER;
}

1;

__END__

=head1 NAME

GunghoX::FollowLinks::Rule::URI - Follow Dependig On URI

=head1 SYNOPSIS

  use GunghoX::FollowLinks::Rule qw(FOLLOW_ALLOW FOLLOW_DENY);
  use GunghoX::FollowLinks::Rule::URI;

  GunghoX::FollowLinks::Rule::URI->new(
    match => [
      { action => FOLLOW_DENY,  host => qr/^.+\.example\.org$/ },
      { action => FOLLOW_ALLOW, host => qr/^.+\.example\.com$/ },
    ]
  );

=head1 DESCRIPTION

This is a rule that matches against a URL using URI::Match.

=head1 METHODS

=head2 apply

=cut
