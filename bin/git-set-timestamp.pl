#!/usr/bin/perl
use strict;
use warnings;
use Path::Class;
use lib file (__FILE__)->dir->parent->subdir ('modules')->subdir ('cmdutils')->subdir ('lib')->stringify;
#use Extras::Path::Class;

my $repository_d = dir (shift);
die "Usage: $0 git-repository-directory\n" unless -d $repository_d;

my $exclude_pattern = qr[^(?>(?>modules|\.git)(?>/|$))];

#$repository_d->v_chdir;
chdir $repository_d;

$repository_d->recurse (callback => sub {
  my $f = $_[0]->relative;
  return if $f =~ /$exclude_pattern/o;
  return unless -f $f;
  
  my $quoted = quotemeta $f->stringify;

  ## Modified?
  my $diff = `git diff --name-only $quoted`;
  return if $diff =~ /\w/;

  my $current_timestamp = $f->stat->mtime or return;
  my $git_timestamp = (`git log -1 --format=%at $quoted` || 0)+0 or return;
  
  my $new_timestamp = $git_timestamp;
  $new_timestamp = $current_timestamp if $current_timestamp < $git_timestamp;
  
  return if $new_timestamp == $current_timestamp;

  printf STDERR "%s (%s -> %s)\n",
      $f->stringify,
      scalar localtime $current_timestamp,
      scalar localtime $new_timestamp;
  utime $new_timestamp, $new_timestamp, $f->stringify;
});
