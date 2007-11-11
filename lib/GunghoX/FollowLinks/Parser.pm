# $Id: /mirror/perl/GunghoX-FollowLinks/trunk/lib/GunghoX/FollowLinks/Parser.pm 8905 2007-11-11T05:32:04.269151Z daisuke  $
#
# Copyright (c) 2007 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

package GunghoX::FollowLinks::Parser;
use strict;
use warnings;
use base qw(Gungho::Base);
use Gungho::Request;
use Gungho::Util;
use GunghoX::FollowLinks::Rule qw(FOLLOW_ALLOW FOLLOW_DENY);

__PACKAGE__->mk_accessors($_) for qw(rules content_type);

sub parse { die "Must override parse()" }

sub register
{
    my ($self, $c) = @_;
    my $ct = $self->content_type;
    $c->follow_links_parsers->{ $ct } = $self;
}

sub new
{
    my $class = shift;
    my %args  = @_;

    my @rules;
    foreach my $rule (@{ $args{rules} }) {
        if (! eval { $rule->isa('GunghoX::FollowLinks::Rule') } || $@) {
            my $module = $rule->{module};
            my $pkg = Gungho::Util::load_module($module, "GunghoX::FollowLinks::Rule");
            $rule = $pkg->new( %{ $rule->{config} } );
        }
        push @rules, $rule;
    }
    return $class->next::method(
        content_type => 'DEFAULT',
        @_,
        rules => \@rules
    );
}

sub apply_rules
{
    my ($self, $c, $response, $url, $attrs) = @_;

    my $rules = $self->rules ;
    my $decision;
    foreach my $rule (@{ $rules }) {
        $decision = $rule->apply( $c, $response, $url, $attrs );
        if ($decision == FOLLOW_ALLOW || $decision == FOLLOW_DENY) {
            last;
        }
    }

    return $decision == FOLLOW_ALLOW;
}

sub follow_if_allowed
{
    my ($self, $c, $response, $url, $attrs) = @_;
    if ($self->apply_rules( $c, $response, $url, $attrs ) ) {
        $c->pushback_request( Gungho::Request->new( GET => $url ) );
    }
}

1;

__END__

=head1 NAME

GunghoX::FollowLinks::Parser - Base Class For FollowLinks Parser

=head1 METHODS

=head2 new(%args)

=head2 content_type

=head2 rules

=head2 register

=head2 parse

=head2 apply_rules

=head2 follow_if_allowed

=cut
