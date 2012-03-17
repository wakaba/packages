all: perl/index.html

perl/index.html: $(wildcard data/perl/*.json) bin/mkperllist.pl
	perl bin/mkperllist.pl > $@
