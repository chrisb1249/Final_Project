W205 Final Project
Chris Bennett

Mail Distribution Center Evaluation and Rest API
Setup Instructions

NOTE: Once these steps have been followed, you can run the 'system' over and over
again by copying in new data files into HDFS, and running the export_tbl.sh script
to update the data in Postgres.

1. Setup a new EC2 instance using the AMI -> UCB W205 Spring Ex 2 Image (ami-4cf9f826)
Create an ECB (although an S3 will work fine) and attach to the EC2

Requirements that the above AMI will address:
   -PostGresSQL installed
   -Python 2.7 installed
   -Hadoop and Hive installed

2. Connect to the new EC2 instance and mount drive
#fdisk -l
#mount -t ext4 <diskvolume> /data
#chmod a+rwx /data

2b. Clone Github repos to new /data directory
-Clone the data from my git hub repository onto the /data directory
-git@github.com:chrisb1249/Final_Project.git

3. Startup Hadoop, Postgres and Metastore
#sh start_hadoop.sh
#cd /data
#sh start_postgres.sh
#sh start_metastore.sh

4. Setup Postgres - Copy over modified config files
#rename ./pgsql/data/postgresql.conf postgresql.bak
#cp ./Final_Project/postgresql.conf ./pgsql/data/postgresql.conf
#rename ./pgsql/data/pg_hba.conf pg_hba.bak
#cp ./Final_Project/pg_hba.conf ./pgsql/data/pg_hba.conf

5. Setup Postgres
#su postgres
$initdb -D /data/pgsql/maildb

6. Create Database in Postgres
$CREATE USER postgres WITH PASSWORD 'pass';
$CREATE DATABASE maildb;
$ALTER DATABASE maildb OWNER TO postgres;
$GRANT ALL ON DATABASE maildb TO postgres;
$\q (to quit pgsql)

7. Verify the database is working
#psql -U postgres -d maildb

8. Create the lsstate table
Run the following statement while logged into Postgres:
$CREATE TABLE lsstate
(lettershop char(4),
state char(2),
cnt char(10),
averagepostal char(10),
stdevpostal char(10),
varpostal char(10),
averagedays char(10),
stdevdays char(10),
vardays char(10));

9. Verify that the table created correctly by running:
\d+ lsstate

10. Exit Postgres
\q
Change Directory to /data/Final_Project/scripts

11. Create HDFS directory and Hive Table(s) and copy data files into directory (only a few data files included)
#su - w205
#cd /data/Final_Project/Scripts
#sh hdfs_script.sh
#sh create_hive_tables.sh

12. Now run the queries in Hive, export the data, and import into Postgres
#sh export_tbl.sh

13. Setup a virtual environment for the REST API
$cd /data/Final_Project/scripts/mailapi
$virtualenv api
$source api/bin/activate

14. Install the requirements into the environment by typing:
$pip install -r requirements.txt

15. Run the REST API
$python api.py

16. To test the API, open a different Terminal console and run:
>>curl http://<IPADDRESS OF NEW EC2>>/fastest/<STATE>
   This api gives you the fastest distribution center for a particular state
   You can test this API with any 2 letter state abbreviation

>>curl http://<IPADDRESS OF NEW EC2>>/stats/<LETTERSHOP>
   This api gives you all roll-up stats for any particular distribution center
   You can test with using "DATM" for the <lettershop>

>>curl http://<IPADDRESS OF NEW EC2>>/statestat/<LETTERSHOP>
   This api gives you all stats for any particular state
   You can test with using "DATM" for the <lettershop>

Note: The other part of this project was to generate numerous Tableau graphs.
Please refer to my powerpoint that was submitted to view those data visualizations.
