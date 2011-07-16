del hatena-star-everywhere.crx
del hatena-star-everywhere.zip
"%USERPROFILE%\Local Settings\Application Data\Google\Chrome\Application\chrome.exe" --pack-extension="%CD%\hatena-star-everywhere" --pack-extension-key="%CD%\hatena-star-everywhere.pem"
mkdir tmp
cp -R hatena-star-everywhere tmp/hatena-star-everywhere
perl -e "local $/ = undef; my $s = <>; $s =~ s{\x22update_url\x22\s*:\s*\x22[^\x22]*\x22\s*,\s*}{}; $s =~ s{(\x22[^\x22]*\x22)|/\*.*?\*/}{$1}gs; print $s" < hatena-star-everywhere\manifest.json > tmp\hatena-star-everywhere\manifest.json
perl -e "local $/ = undef; my $s = <>; $s =~ s{\x22update_url\x22\s*:\s*\x22[^\x22]*\x22\s*,\s*}{}; $s =~ s{(\x22[^\x22]*\x22)|/\*.*?\*/}{$1}gs; print $s" < hatena-star-everywhere\_locales\ja\messages.json > tmp\hatena-star-everywhere\_locales\ja\messages.json
perl -e "local $/ = undef; my $s = <>; $s =~ s{\x22update_url\x22\s*:\s*\x22[^\x22]*\x22\s*,\s*}{}; $s =~ s{(\x22[^\x22]*\x22)|/\*.*?\*/}{$1}gs; print $s" < hatena-star-everywhere\_locales\en\messages.json > tmp\hatena-star-everywhere\_locales\en\messages.json
perl -e "local $/ = undef; my $s = <>; $s =~ s{\x22update_url\x22\s*:\s*\x22[^\x22]*\x22\s*,\s*}{}; $s =~ s{(\x22[^\x22]*\x22)|/\*.*?\*/}{$1}gs; print $s" < hatena-star-everywhere\_locales\en_GB\messages.json > tmp\hatena-star-everywhere\_locales\en_GB\messages.json
cd tmp
zip ../hatena-star-everywhere.zip hatena-star-everywhere -r
cd ..
rm -fr ./tmp
