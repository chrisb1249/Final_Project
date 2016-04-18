DROP TABLE lsstate_stats;

CREATE TABLE lsstate_stats AS SELECT lettershop, state, count(*) as cnt, round(avg(deliverydayspostal),3) as averagepostal, round(stddev_pop(deliverydayspostal),3) as stdevpostal, round(variance(deliverydayspostal),3) as varpostal, round(avg(deliverydays),3) as averagedays, round(stddev_pop(deliverydays),3) as stdevdays, round(variance(deliverydays),3) as vardays from mail where mailtype = "Std" group by lettershop, state;

DROP TABLE lssummary_stats;

CREATE TABLE lssummary_stats AS SELECT lettershop, count(*) as cnt, round(avg(deliverydayspostal),3) as averagepostal, round(stddev_pop(deliverydayspostal),3) as stdevpostal, round(variance(deliverydayspostal),3) as varpostal, round(avg(deliverydays),3) as averagedays, round(stddev_pop(deliverydays),3) as stdevdays, round(variance(deliverydays),3) as vardays from mail where mailtype = "Std" group by lettershop;  

DROP TABLE lszipbyday_stats;

CREATE TABLE lszipbyday_stats AS SELECT lettershop, deliverydays, deliveryzip, count(*) as cnt from mail where mailtype = "Std" and deliverydays < 20 group by lettershop, deliverydays, deliveryzip;
