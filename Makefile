PERL = perl

all: perl/index.html

perl/index.html: $(wildcard data/perl/*.json) bin/mkperllist.pl
	$(PERL) bin/git-set-timestamp.pl .
	$(PERL) bin/mkperllist.pl > $@
