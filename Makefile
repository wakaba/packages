PERL = local/bin/perl
WGET = wget
GIT = git

all: perl/index.html

local/bin/pmbp.pl:
	mkdir -p local/bin
	$(WGET) -O $@ https://github.com/wakaba/perl-setupenv/raw/master/bin/pmbp.pl

pmbp-upgrade:
	perl local/bin/pmbp.pl --update-pmbp-pl

pmbp-update: local/bin/pmbp.pl pmbp-upgrade
	perl local/bin/pmbp.pl --update

pmbp-install: local/bin/pmbp.pl pmbp-upgrade
	perl local/bin/pmbp.pl --install \
	    --create-perl-command-shortcut local/bin/perl

deps: git-submodules pmbp-install

git-submodules:
	$(GIT) submodule update --init

perl/index.html: $(wildcard data/perl/*.json) \
    deps bin/mkperllist.pl
	$(PERL) bin/git-set-timestamp.pl .
	$(PERL) bin/mkperllist.pl > $@
