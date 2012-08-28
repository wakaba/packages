PERL = perl
PERL_ENV =

all: perl/index.html

perl/index.html: $(wildcard data/perl/*.json) bin/mkperllist.pl
	$(PERL_ENV) $(PERL) bin/git-set-timestamp.pl .
	$(PERL_ENV) $(PERL) bin/mkperllist.pl > $@
