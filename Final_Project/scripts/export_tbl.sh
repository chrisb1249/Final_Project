rm ./data/lsstate_stats_dump.bak
cp ./data/lsstate_stats_dump.csv ./data/lsstate_stats_dump.bak
rm ./data/lssummary_stats_dump.bak
cp ./data/lssummary_stats_dump.csv ./data/lssummary_stats_dump.bak
rm ./data/lszipbyday_stats_dump.bak 
cp ./data/lszipbyday_stats_dump.csv ./data/lszipbyday_stats_dump.bak

hive -e 'select * from lsstate_stats' | sed 's/[/t]/,/g' > ./data/lsstate_stats_dump.csv

hive -e 'select * from lssummary_stats' | sed 's/[/t]/,/g' > ./data/lssummary_stats_dump.csv

hive -e 'select * from lszipbyday_stats' | sed 's/[/t]/,/g' > ./data/lszipbyday_stats_dump.csv

psql -U postgres -d maildb -c "COPY lsstate FROM '/data/Final_Project/scripts/data/lsstate_stats_dump.csv' delimiter E'\t' csv;"
\q

