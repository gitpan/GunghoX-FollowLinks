# $Id: /mirror/perl/GunghoX-FollowLinks/trunk/lib/GunghoX/FollowLinks/Parser.pm 8919 2007-11-12T03:03:30.295953Z daisuke  $
#
# Copyright (c) 2007 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

package GunghoX::FollowLinks::Parser;
use strict;
use warnings;
use base qw(Gungho::Base);
use Gungho::Request;
use Gungho::Util;
use GunghoX::FollowLinks::Rule qw(FOLLOW_ALLOW FOLLOW_DENY FOLLOW_DEFER);

__PACKAGE__->mk_accessors($_) for qw(rules content_type merge_rule);

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
        merge_rule   => 'ANY',
        @_,
        rules => \@rules
    );
}

sub apply_rules
{
    my ($self, $c, $response, $url, $attrs) = @_;

    $c->log->debug( "Applying rules for $url" );
    my $rules = $self->rules ;
    my $decision;
    my @decision;
    foreach my $rule (@{ $rules }) {
        $decision = $rule->apply( $c, $response, $url, $attrs );
        if ($decision eq FOLLOW_ALLOW || $decision eq FOLLOW_DENY) {
            $c->log->debug( " + Rule $rule " . (
                $decision eq FOLLOW_ALLOW ? "ALLOW" :
                $decision eq FOLLOW_DENY ? "DENY" :
                $decision eq FOLLOW_DEFER ? "DEFER" :
                "UNKNOWN"
            ) . " for url $url");

            if ($self->merge_rule eq 'ANY') {
                $c->log->debug( " * Merge rule is 'ANY', stopping rules");
                last;
            }
        }
        push @decision, $decision;
    }

    if ($self->merge_rule eq 'ALL') {
        my @allowed = grep { $_ eq FOLLOW_ALLOW } @decision;
        $c->log->debug( "Merge rule is 'ALL'. " . scalar @allowed . " ALLOWs from " . scalar @decision . " decisions");
        $decision = (@allowed == @decision) ? FOLLOW_ALLOW :  FOLLOW_DENY;
    }

    return ($decision || FOLLOW_DEFER) eq FOLLOW_ALLOW;
}

sub follow_if_allowed
{
    my ($self, $c, $response, $url, $attrs) = @_;
    if ($self->apply_rules( $c, $response, $url, $attrs ) ) {
        $c->log->debug( "$url is allowed" );
        $c->pushback_request( Gungho::Request->new( GET => $url ) );
    } else {
        $c->log->debug( "$url is denied" );
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
