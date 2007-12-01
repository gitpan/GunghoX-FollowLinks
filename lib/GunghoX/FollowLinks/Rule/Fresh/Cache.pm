# $Id: /mirror/perl/GunghoX-FollowLinks/trunk/lib/GunghoX/FollowLinks/Rule/Fresh/Cache.pm 31640 2007-12-01T15:48:28.904993Z daisuke  $
#
# Copyright (c) 2007 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

package GunghoX::FollowLinks::Rule::Fresh::Cache;
use strict;
use warnings;
use base qw(Class::Accessor::Fast);

__PACKAGE__->mk_accessors($_) for qw(cache);

sub new
{
    my $class = shift;
    my %args  = @_;

    my $cache_config = delete $args{cache};
    my $cache_module = Gungho::Util::load_module(
        $cache_config->{module} || die "No cache module specified"
    );
    my $cache = $cache_module->new( %{ $cache_config->{config} || {} } );
    
    return bless { cache => $cache }, $class;
}

sub put
{
    my ($self, $url) = @_;
    $self->cache->set($url, 1);
}

sub get
{
    my ($self, $url) = @_;
    $self->cache->get($url);
}

1;

__END__

=head1 NAME 

GunghoX::FollowLinks::Rule::Fresh::Cache - Store URLs In A Cache Of Your Choice

=head1 METHODS

=head2 new

=head2 put

=head2 get

=cut