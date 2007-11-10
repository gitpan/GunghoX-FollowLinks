# $Id: /mirror/perl/GunghoX-FollowLinks/trunk/lib/GunghoX/FollowLinks/Rule.pm 8893 2007-11-10T14:30:51.466577Z daisuke  $
#
# Copyright (c) 2007 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

package GunghoX::FollowLinks::Rule;
use strict;
use warnings;
use base qw(Gungho::Base);

use Sub::Exporter -setup => {
    exports => [ qw(FOLLOW_ALLOW FOLLOW_DENY FOLLOW_DEFER) ]
};
use constant FOLLOW_ALLOW => 1;
use constant FOLLOW_DENY  => 0;
use constant FOLLOW_DEFER => -1;

sub apply { die "You must override apply()" }

1;

__END__

=head1 NAME

GunghoX::FollowLinks::Rule - Rule To Decide If A Link Should Be Followed

=head1 METHODS

=head2 apply

Subclasses must override this method. The exact arguments change depending
on the GunghoX::FollowLinks::Parser object being used, but the first two
elements are always the global Gungho context and the Gungho::Response
object.

=cut
