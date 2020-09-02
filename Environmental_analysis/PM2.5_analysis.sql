--4. PM2.5 AEROSOLES EMISSION (no data for PM10) 
select distinct indicatorname from bazafin b 
where indicatorname ilike '%PM%';
 
--selection of indicator which informs about population endangered by exceeded (according to WHO) PM2.5 emission
select * from bazafin
where indicatorname ilike '%PM%WHO%';
 
--definition of table (ranking in analysed time interval for PM2.5 indicator) to compare with other environmental indicators
create table PM25_2 as (
with PM25 as (
select 
	shortname, 
	value, 
	"Year" 
from bazafin
where indicatorname ilike '%PM%WHO%')
select 
	round(avg(value),2) as r_value, shortname, 
	"Year"
from PM25
group by shortname, "Year"
order by "Year");

create table PM25_ranking as 
(select 
	*, 
	dense_rank () over (partition by "Year" order by r_value desc) as PM25_ranking 
from pm25_2);

--NULLs are the consequence of incomplete dataset (years 1990, 1995, 2000, 2005, 2010, 2011, 2013 only)
select distinct "Year" from pm25_ranking 
order by "Year";

select distinct "Year" from bazafin b 
order by "Year";

--change as percentage of 13 years difference
select * from pm25_ranking pr 
where shortname in ('China', 'United States', 'India', 'Japan', 'Germany') 
	and ("Year" = 1990 or "Year" = 2013) 
order by shortname, "Year"; 

--confirmation of number of countries in each year 
select count (distinct shortname) as count_1990 from pm25_ranking pr where "Year" = 1990 
union 
select count (distinct shortname) as count_2013 from pm25_ranking pr where "Year" = 1995
union 
select count (distinct shortname) as count_2013 from pm25_ranking pr where "Year" = 2000
union 
select count (distinct shortname) as count_1990 from pm25_ranking pr where "Year" = 2005
union 
select count (distinct shortname) as count_1990 from pm25_ranking pr where "Year" = 2010
union 
select count (distinct shortname) as count_1990 from pm25_ranking pr where "Year" = 2013 --185;

--max value in dataset
select max(r_value) from pm25_ranking pr; --100

--1990-2013 value difference; percentage of change 
select 
	shortname, 
	"Year", 
	r_value, 
	(r_value) * 100 / (select max (r_value) from pm25_ranking pr2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from pm25_ranking pr2)) ) as margin 
from (
select 
	shortname, 
	"Year", r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from pm25_ranking pr 
where shortname ilike 'United States' 
	and ("Year" = 1990 or "Year" = 2013)
order by shortname, "Year") as new_P25) 
as new_2_P25;


-- additional: mean value 
select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from pm25_ranking pr2), 
	r_value, (r_value) * 100 / (select max (r_value) from pm25_ranking pr2), 
	( lag - ((r_value) * 100 / (select max (r_value) from pm25_ranking pr2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from pm25_ranking pr 
where shortname ilike 'United States' and ("Year" = 1990 or "Year" = 2013)
order by shortname, "Year") as new_P25) 
as new_2_P25;

