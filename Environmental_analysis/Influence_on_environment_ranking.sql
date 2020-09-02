--ENVIRONMENTAL INDOCATORS: INFLUENCE OF 5  SELECTED MVPs
--('China', 'United States', 'India', 'Japan', 'Germany')

--1. definition of table (ranking in analysed time interval for PM2.5 indicator) to compare with other environmental indicators 
--a) population endangered (as percent of population) by exceeded (according to WHO) PM2.5 emission
create table PM25_ranking as (
select 
	*, 
	dense_rank () over (partition by "Year" order by r_value desc) as PM25_ranking 
from (
with PM25 as (
select 
	shortname, 
	value, 
	"Year" 
from bazafin
where indicatorname ilike '%PM%WHO%')
select 
	round(avg(value),2) as r_value, 
	shortname, 
	"Year"
from PM25
group by shortname, "Year"
order by shortname, "Year") as PM_2) ;


--b) percentage of fossil fuel usage

create table rewewable_ranking as (
select 
	*, 
	dense_rank () over (partition by "Year" order by r_value desc) as rewewable_ranking 
from (
with rewewable as (
select 
	shortname, 
	value, 
	"Year" 
from bazafin
where indicatorname ilike '%renewable energy consumption%')
select 
	round(avg(value),2) as r_value, 
	shortname, 
	"Year"
from rewewable 
group by shortname, "Year"
order by shortname, "Year") as rewewable_2);


--c) average CO2 emission per capita
	
create table CO2_ranking as 
(select *, dense_rank () over (partition by "Year" order by r_value desc) as CO2_ranking 
	from 
	(with CO2 as 
		(select shortname, value, "Year" 
		from bazafin
		where indicatorname ilike '%CO2%metric%')
	select round(avg(value),2) as r_value, shortname, "Year"
	from CO2 
	group by shortname, "Year"
	order by shortname, "Year") as CO2_2)
	
--d) percentage of fossil fuel usage - average for countries in time interval
create table fossil_ranking as (
select 
	*, 
	dense_rank () over (partition by "Year" order by r_value desc) as fossil_ranking 
from (
with fossil as (
select 
	shortname, 
	value, 
	"Year" 
from bazafin
where indicatorname ilike '%fossil%fuel%consumption%')
select 
	round(avg(value),2) as r_value, 
	shortname, 
	"Year"
from fossil 
group by shortname, "Year"
order by shortname, "Year") as fossil_2);
	
--2. gain/fall (per cent) as change between 1990 and 2013 (unfortunately for loop crashes software)

	
	--CHINA

	
--a) population endangered (as percent of population) by exceeded (according to WHO) PM2.5 emission

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from pm25_ranking pr2), 
	r_value, 
	(r_value) * 100 / (select max (r_value) from pm25_ranking pr2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from pm25_ranking pr2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from pm25_ranking pr 
where shortname ilike 'China' 
	and "Year" in ('1990', '2013')
order by shortname, 
	"Year") as new_P25) 
as new_2_P25;

--b) percentage of renewable energy sourves (years 1990-2011)

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from rewewable_ranking r2), 
	r_value, 
	(r_value) * 100 / (select max (r_value) from rewewable_ranking r2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from rewewable_ranking r2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from rewewable_ranking r2
where shortname ilike 'China' 
	and "Year" in ('1990', '2012')
order by shortname, 
	"Year") as new_rewewable) 
as new_rewewable2_P25;

--c) average CO2 emission per capita (years 1990-2011)

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from CO2_ranking co2), 
	r_value, 
	(r_value) * 100 / (select max (r_value) from CO2_ranking co2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from CO2_ranking co2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from CO2_ranking co2
where shortname ilike 'China' 
	and "Year" in ('1990', '2011')
order by shortname, 
	"Year") as newCO2) 
as newCO2_2;

--d) percentage of fossil fuels energy - average value for countries in time interval (years 1990-2011) 

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from fossil_ranking fr), 
	r_value,
	(r_value) * 100 / (select max (r_value) from fossil_ranking fr) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from fossil_ranking fr)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from fossil_ranking fr
where shortname ilike 'China' 
	and "Year" in ('1990', '2012')
order by shortname, 
	"Year") as new_fossil) 
as new_fossil2;

	
	-- USA

	
--a) population endangered (as percent of population) by exceeded (according to WHO) PM2.5 emission

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from pm25_ranking pr2), 
	r_value, 
	(r_value) * 100 / (select max (r_value) from pm25_ranking pr2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from pm25_ranking pr2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from pm25_ranking pr 
where shortname ilike 'United States' 
	and "Year" in ('1990', '2013')
order by shortname, 
	"Year") as new_P25) 
as new_2_P25;

--b) percentage of renewable energy sourves (years 1990-2011)

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from rewewable_ranking r2), 
	r_value, 
	(r_value) * 100 / (select max (r_value) from rewewable_ranking r2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from rewewable_ranking r2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from rewewable_ranking r2
where shortname ilike 'United States' 
	and "Year" in ('1990', '2012')
order by shortname, 
	"Year") as new_rewewable) 
as new_rewewable2_P25;

--c) average CO2 emission per capita (years 1990-2011)

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from CO2_ranking co2), 
	r_value,
	(r_value) * 100 / (select max (r_value) from CO2_ranking co2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from CO2_ranking co2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from CO2_ranking co2
where shortname ilike 'United States' 
	and "Year" in ('1990', '2011')
order by shortname, 
	"Year") as newCO2) 
as newCO2_2;

--d) percentage of fossil fuels energy - average value for countries in time interval (years 1990-2011) 

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from fossil_ranking fr), 
	r_value, 
	(r_value) * 100 / (select max (r_value) from fossil_ranking fr) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from fossil_ranking fr)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from fossil_ranking fr
where shortname ilike 'United States' 
	and "Year" in ('1990', '2012')
order by shortname, 
	"Year") as new_fossil) 
as new_fossil2;

	
	-- INDIA 


--a) population endangered (as percent of population) by exceeded (according to WHO) PM2.5 emission

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from pm25_ranking pr2), 
	r_value, 
	(r_value) * 100 / (select max (r_value) from pm25_ranking pr2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from pm25_ranking pr2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from pm25_ranking pr 
where shortname ilike 'india' 
	and "Year" in ('1990', '2013')
order by shortname, 
	"Year") as new_P25) 
as new_2_P25;

--b) percentage of renewable energy sourves (years 1990-2011)

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from rewewable_ranking r2), 
	r_value, 
	(r_value) * 100 / (select max (r_value) from rewewable_ranking r2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from rewewable_ranking r2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from rewewable_ranking r2
where shortname ilike 'india' 
	and "Year" in ('1990', '2012')
order by shortname, 
	"Year") as new_rewewable) 
as new_rewewable2_P25;

--c) average CO2 emission per capita (years 1990-2011)

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from CO2_ranking co2), 
	r_value,
	(r_value) * 100 / (select max (r_value) from CO2_ranking co2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from CO2_ranking co2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from CO2_ranking co2
where shortname ilike 'india' 
	and "Year" in ('1990', '2011')
order by shortname, 
	"Year") as newCO2) 
as newCO2_2;

--d) percentage of fossil fuels energy - average value for countries in time interval (years 1990-2011) 

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from fossil_ranking fr), 
	r_value, 
	(r_value) * 100 / (select max (r_value) from fossil_ranking fr) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from fossil_ranking fr)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from fossil_ranking fr
where shortname ilike 'india' 
	and "Year" in ('1990', '2012')
order by shortname, 
	"Year") as new_fossil) 
as new_fossil2;


	
	-- JAPAN

--a) population endangered (as percent of population) by exceeded (according to WHO) PM2.5 emission

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from pm25_ranking pr2), 
	r_value, 
	(r_value) * 100 / (select max (r_value) from pm25_ranking pr2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from pm25_ranking pr2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from pm25_ranking pr 
where shortname ilike 'japan' 
	and "Year" in ('1990', '2013')
order by shortname, 
	"Year") as new_P25) 
as new_2_P25;

--b) percentage of renewable energy sourves (years 1990-2011)

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from rewewable_ranking r2), 
	r_value, 
	(r_value) * 100 / (select max (r_value) from rewewable_ranking r2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from rewewable_ranking r2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from rewewable_ranking r2
where shortname ilike 'japan' 
	and "Year" in ('1990', '2012')
order by shortname, 
	"Year") as new_rewewable) 
as new_rewewable2_P25;

--c) average CO2 emission per capita (years 1990-2011)

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from CO2_ranking co2), 
	r_value,
	(r_value) * 100 / (select max (r_value) from CO2_ranking co2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from CO2_ranking co2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from CO2_ranking co2
where shortname ilike 'japan' 
	and "Year" in ('1990', '2011')
order by shortname, 
	"Year") as newCO2) 
as newCO2_2;

--d) percentage of fossil fuels energy - average value for countries in time interval (years 1990-2011) 

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from fossil_ranking fr), 
	r_value, 
	(r_value) * 100 / (select max (r_value) from fossil_ranking fr) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from fossil_ranking fr)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from fossil_ranking fr
where shortname ilike 'japan' 
	and "Year" in ('1990', '2012')
order by shortname, 
	"Year") as new_fossil) 
as new_fossil2;


	-- GERMANY


--a) population endangered (as percent of population) by exceeded (according to WHO) PM2.5 emission

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from pm25_ranking pr2), 
	r_value, 
	(r_value) * 100 / (select max (r_value) from pm25_ranking pr2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from pm25_ranking pr2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from pm25_ranking pr 
where shortname ilike 'germany' 
	and "Year" in ('1990', '2013')
order by shortname, 
	"Year") as new_P25) 
as new_2_P25;

--b) percentage of renewable energy sourves (years 1990-2011)

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from rewewable_ranking r2), 
	r_value, 
	(r_value) * 100 / (select max (r_value) from rewewable_ranking r2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from rewewable_ranking r2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from rewewable_ranking r2
where shortname ilike 'germany'' 
	and "Year" in ('1990', '2012')
order by shortname, 
	"Year") as new_rewewable) 
as new_rewewable2_P25;

--c) average CO2 emission per capita (years 1990-2011)

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from CO2_ranking co2), 
	r_value,
	(r_value) * 100 / (select max (r_value) from CO2_ranking co2) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from CO2_ranking co2)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from CO2_ranking co2
where shortname ilike 'germany' 
	and "Year" in ('1990', '2011')
order by shortname, 
	"Year") as newCO2) 
as newCO2_2;

--d) percentage of fossil fuels energy - average value for countries in time interval (years 1990-2011) 

select 
	shortname, 
	"Year", 
	(select round(avg (r_value),2) from fossil_ranking fr), 
	r_value, 
	(r_value) * 100 / (select max (r_value) from fossil_ranking fr) as per_cent, 
	( lag - ((r_value) * 100 / (select max (r_value) from fossil_ranking fr)) ) as margin 
from (
select 
	shortname, 
	"Year", 
	r_value, 
	(lag(r_value) over (order by "Year")) as lag 
from (
select * from fossil_ranking fr
where shortname ilike 'germany' 
	and "Year" in ('1990', '2012')
order by shortname, 
	"Year") as new_fossil) 
as new_fossil2;

-- 3. RANKING

create table ranking_table as (
select 
	pm25_ranking.shortname, 
	pr."Year", 
	pr.pm25_ranking, 
	rr.rewewable_ranking, 
	co2.co2_ranking, 
	f.fossil_ranking 
from 
(select * from pm25_ranking pr 
full join rewewable_ranking rr 
	on (pr.shortname = rr.shortname and pr."Year" = rr."Year") 
full join co2_ranking co2 
	on (pr.shortname = co2.shortname and pr."Year" = co2."Year") 
full join fossil_ranking f 
	on (pr.shortname = f.shortname and pr."Year" = f."Year")  ) as ranking2 
where "Year" in ('1990', '2011', '2012', '2013'));

create table pm25_ranking_helper_table as (
select 
	r_value, 
	shortname as pr_shortname, 
	"Year" as pr_Year, 
	pm25_ranking 
from pm25_ranking pr3);

select * from pm25_ranking_helper_table;

select 
	pr_shortname, 
	pr_Year, 
	pm25_ranking,
	rewewable_ranking, 
	co2_ranking, 
	fossil_ranking from (
select * from pm25_ranking_pomocnicza pr
full join rewewable_ranking rr 
	on (pr.pr_shortname = rr.shortname and pr.pr_Year = rr."Year") 
full join co2_ranking co2 
	on (pr.pr_shortname = co2.shortname and pr.pr_Year = co2."Year") 
full join fossil_ranking f 
	on (pr.pr_shortname = f.shortname and pr.pr_Year = f."Year")
where pr_shortname in  ('China', 'United States', 'India', 'Japan', 'Germany') 
	and pr.pr_Year in ('1990', '2011') 
order by pr.pr_shortname, 
	pr.pr_Year) as table_1;

