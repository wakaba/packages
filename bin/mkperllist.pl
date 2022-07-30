#!/usr/bin/perl
use strict;
use warnings;
use Path::Class;
use lib glob file (__FILE__)->dir->parent->subdir ('modules', '*', 'lib')->stringify;
use JSON::Functions::XS qw(file2perl);

my $json_d = file (__FILE__)->dir->parent->subdir ('data', 'perl');
my $tar_d = file (__FILE__)->dir->parent->subdir ('perl');

my $data = {};

while (my $json_f = $json_d->next) {
  next unless $json_f =~ /\.json$/;
  my $json = file2perl $json_f;
  $data->{$json->{dist_name}}->{$json->{version}} = $json;
}

sub url ($) {
  my $s = shift;
  $s =~ s{^https?://suika.fam.cx/}{https://suika.suikawiki.org/};
  return $s;
}

sub htescape ($) {
  my $s = shift;
  $s =~ s/&/&amp;/g;
  $s =~ s/\"/&quot;/g;
  $s =~ s/</&lt;/g;
  $s =~ s/>/&gt;/g;
  return $s;
} # htescape

sub size_label ($) {
  my $size = shift;
  if ($size < 1024) {
    return $size . ' bytes';
  }
  $size = int ($size / 1024);
  return $size . 'KB';
} # size_label

sub timestamp ($) {
  return scalar (gmtime $_[0]) . ' UTC';
} # timestamp

sub rfc3339 ($) {
  my @time = gmtime $_[0];
  return sprintf '%04d-%02d-%02dT%02d:%02d:%02dZ',
      $time[5] + 1900, $time[4] + 1, $time[3], $time[2], $time[1], $time[0];
} # rfc3339

print qq{<!DOCTYPE HTML><html lang=en><title>Perl packages</title>
<link rel=stylesheet href="https://suika.suikawiki.org/www/style/html/xhtml">
<link rel=author href="https://suika.suikawiki.org/~wakaba/who?" title=Wakaba>
<h1>Perl packages</h1>

<p>Note that these snapshot packages might be <em>outdated</em>.  The
latest version of these modules are avaialble from their Git
repositories.  Use of the Git version is always recommended.</p>

<section id=toc>
<h2>Modules</h2>

<ul>
};

for my $dist_name (sort { $a cmp $b } keys %{$data}) {
  printf q{<li><a href="#%s">%s</a>},
      htescape $dist_name, htescape $dist_name;
}

print q{</ul></section>};

for my $dist_name (sort { $a cmp $b } keys %{$data}) {
  printf q{<section id="%s"><h2>%s</h2><dl>},
      htescape $dist_name,
      htescape $dist_name;

  my $count = 0;
  for my $version (sort { $b cmp $a } keys %{$data->{$dist_name}}) {
    my $info = $data->{$dist_name}->{$version};
    if ($count == 0) {
      my $desc = join '',
          map { /^     / ? '<pre>' . $_ . '</pre>' : '<p>' . $_ }
          split /\n{2,}/, htescape $info->{desc};
      printf q{<dt>%s %s<dd>%s},
          htescape $info->{name}, htescape $info->{version}, $desc;

      my $tar_name = $info->{dist_name} . '-' . $info->{version} . '.tar.gz';
      my $tar_f = $tar_d->file ($tar_name);
      my $tar_stat = $tar_f->stat;
      printf q{<dt>Tarball<dd><a href="%s">%s</a>
               (%s, <time datetime="%s">%s</time>)},
          htescape $tar_name, htescape $tar_name,
          htescape size_label $tar_stat->size,
          htescape rfc3339 $tar_stat->mtime,
          htescape timestamp $tar_stat->mtime;

      if (keys %{$info->{urls}->{git} or {}}) {
        print q{<dt>Git repository};
        for (keys %{$info->{urls}->{git}}) {
          printf q{<dd><a href="%s">%s</a>},
              htescape url $info->{urls}->{git}->{$_}, htescape $_;
        }
      }

      if (keys %{$info->{urls}->{ci} or {}}) {
        print q{<dt>Continuous integration};
        for (keys %{$info->{urls}->{ci}}) {
          printf q{<dd><a href="%s">%s</a>},
              htescape url $info->{urls}->{ci}->{$_}, htescape $_;
        }
      }
    } else {
      if ($count == 1) {
        print q{<dt>Old version};
        print q{s} if 2 < keys %{$data->{dist_name}};
      }
      my $tar_name = $info->{dist_name} . '-' . $info->{version} . '.tar.gz';
      my $tar_f = $tar_d->file ($tar_name);
      my $tar_stat = $tar_f->stat;
      printf q{<dd><a href="%s">%s</a>
               (%s, <time datetime="%s">%s</time>)},
          htescape $tar_name, htescape $tar_name,
          htescape size_label $tar_stat->size,
          htescape rfc3339 $tar_stat->mtime,
          htescape timestamp $tar_stat->mtime;
    }
    $count++;
  }
  print q{</dl></section>};
}

print q{

<hr>

<footer>
  <p>See also: <a href="https://github.com/wakaba/packages">Repository</a>.
  <p>Contact: <a href="mailto:wakaba@suikawiki.org">Wakaba</a>.
</footer>

};
