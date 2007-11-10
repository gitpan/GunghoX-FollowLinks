use strict;
use inc::Module::Install;

name("GunghoX-FollowLinks");
all_from("lib/GunghoX/FollowLinks.pm");

requires('Gungho', '0.09003');
requires('HTML::Parser');
requires('HTML::Tagset');
requires('Sub::Exporter');
requires('URI::Match');

tests('t/*.t t/*/*/*.t');
auto_install;
WriteAll;