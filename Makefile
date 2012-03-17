all: perl.html

perl.html: $(wildcard data/perl/*.json) bin/mkperllist.pl
	perl bin/mkperllist.pl > $@
