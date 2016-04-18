DROP TABLE mailtest;

CREATE EXTERNAL TABLE mail
(jobver string,
program string,
lettershop string,
deliveryzip string,
deliveryscf string,
state string,
deliverydays string,
deliverydayspostal string,
startmaildate string,
endmaildate string,
mailtype string,
maildays string)
ROW FORMAT DELIMITED
STORED AS TEXTFILE
LOCATION '/user/w205/mail';

CREATE VIEW IF NOT EXISTS
vw_stdmail (jobver, program, lettershop, deliveryzip, deliveryscf, state, deliverydays, deliverydayspostal, startmaildate, endmaildate, mailtype, maildays) as select * from mail where mailtype = "Std";

