rm lsstate_stats_dump.bak
cp lsstate_stats_dump.csv lsstate_stats_dump.bak
rm lssummary_stats_dump.bak
cp lssummary_stats_dump.csv lssummary_stats_dump.bak
rm lszipbyday_stats_dump.bak 
cp lszipbyday_stats_dump.csv lszipbyday_stats_dump.bak

hive -e 'select * from lsstate_stats' | sed 's/[/t]/,/g' > lsstate_stats_dump.csv

hive -e 'select * from lssummary_stats' | sed 's/[/t]/,/g' > lssummary_stats_dump.csv

hive -e 'select * from lszipbyday_stats' | sed 's/[/t]/,/g' > lszipbyday_stats_dump.csv

psql -U postgres -d maildb -c "COPY lsstate FROM '/data/scripts/lsstate_stats_dump.csv' delimiter E'\t' csv;"
\q

