-- COUNTRY SELECTION (5 MVPs FOR CHOSEN INDICATORS)
-- data limitation for years over 1989

create table GDP as (
select * from bazafin  
where indicatorname ilike 'GDP, PPP (current international $)' and "Year" > 1989);

-- highest average GDP value

select 
	shortname, 
	avg(value) 
from GDP 
group by shortname 
order by avg(value) desc
limit 5;


-- highest GDP gain
with DGP_help as (
select 
	shortname, 
	avg(value) as mean, 
	lag(avg(value),10) over (order by shortname) as count_lagged 
from pkb 
group by shortname  
order by avg(value) desc
limit 5)
select 
	*, 
	abs(100*(srednia - count_lagged)/ (count_lagged )) as year_diff 
from GDP_help
order by year_diff desc
limit 5;

-- country selection
create table helper_table as (
select 
	shortname, 
	avg(value) as GDP, 
	"Year" 
from GDP
group by shortname, "Year" 
order by 
	"Year" asc,  
	GDP asc, 
	shortname);

select * from helper_table
where p.shortname in ('China', 'United States', 'India', 'Japan', 'Germany')
order by
	"Year" desc, 
	GDP desc;


-- ENVIRONMENTAL INDOCATORS
--1. Renewable Energy Sources (RES)
-- average percentage for countries


create table renewable as (
select 
	shortname, 
	value as RES, 
	"Year" 
from bazafin
where indicatorname ilike '%renewable energy consumption%')

select 
	round(avg(RES),2) as avg_res_usage, 
	"Year" 
from renewable
group by "Year"
order by "Year";

-- highest and lowest values (best and worst countries) in range

--highest:

select 
	round(avg(RES),2) as avg_res_usage, 
	shortname, 
	"Year", 
	lag(avg(value)) over (order by shortname, "Year") as count_lagged 
from renewable 
group by shortname, 
         "Year"
order by round(max(value),2) asc
limit 10;

--lowest:

select 
	round(avg(RES),2) as mean_res_usage, 
	shortname, 
	"Year", 
	lag(avg(value)) over (order by shortname, "Year") as count_lagged 
from renewable 
group by shortname, 
         "Year"
order by round(max(value),2) desc
limit 10;


-- percentiles 

select 
	percentile_disc(0.25) within group (order by OZE) as p25, --6,06%
	percentile_disc(0.5) within group (order by OZE) as p50, --24,59%
	percentile_disc(0.75) within group (order by OZE) as p75 -- 63,93%
from renewable;

--mean RES usage for countries in time interval
select avg(RES) as mean_world_res_usage from renewable --35,44% 

--yearly change for countries (GDP join RES table)

select * from renewable r
join helper_table ht on ht.shortname = r.shortname
where shortname in ('China', 'United States', 'India', 'Japan', 'Germany')
	and "Year" < 2013
order by "Year" desc, 
	RES desc;

--2. CO2

-- average CO2 emission per person 
create table CO2 as (
select 
	shortname, 
	value, 
	"Year" 
from bazafin
where indicatorname ilike '%CO2%metric%';

select 
	round(avg(value),2) as avg_co2_emission, 
	"Year" 
from co2
group by "Year"
order by "Year";

-- winners and loosers in analysed range

select 
	round(avg(value),2) as avg_co2_emission, 
	shortname, 
	"Year", 
	lag(avg(value)) over (order by shortname, "Year") as count_lagged 
from CO2
group by shortname, 
         "Year"
order by round(max(value),2) asc
limit 10;

select 
	round(avg(value),2) as avg_co2_emission, 
	shortname, 
	"Year", 
	lag(avg(value)) over (order by shortname, "Year") as count_lagged 
from CO2
group by shortname, 
         "Year"
order by round(max(value),2) desc
limit 10;

-- percentiles 

select 
	percentile_disc(0.25) within group (order by co2) as p25, --0,54
	percentile_disc(0.5) within group (order by co2) as p50, --2,22
	percentile_disc(0.75) within group (order by co2) as p75 -- 6,74
from CO2;

--average CO2 emission for countries in time interval
select avg(co2) as avg_co2_emission from CO2 -- 4,73%; 


-- yearly change for countries (GDP join CO2 table)

select * from CO2 c
join helper_table ht on ht.shortname = c.shortname
where shortname in ('China', 'United States', 'India', 'Japan', 'Germany') 
   and "Year" < 2013
order by "Year" desc, 
          CO2 desc;

-- 3. FOSSIL FUEL USAGE
-- percentage of fossil fuel usage in analysed time interval

create table fossil as (
select 
	shortname, 
	value, 
	"Year"
from bazafin
where indicatorname ilike '%fossil%fuel%consumption%');

select 
	round(avg(value),2) as mean_fossfuel_usage, 
	"Year" 
from fossil
group by "Year"
order by "Year";

-- winners and loosers in analysed range 

select 
	round(avg(value),2) mean_fossfuel_usage, 
	shortname, 
	"Year", 
	lag(avg(value)) over (order by shortname, "Year") as count_lagged 
from fossil 
group by shortname, 
         "Year"
order by round(max(value),2) asc
limit 10;

select 
	round(avg(value),2) mean_fossfuel_usage, 
	shortname, 
	"Year", 
	lag(avg(value)) over (order by shortname, "Year") as count_lagged 
from fossil 
group by shortname, 
         "Year"
order by round(max(value),2) desc
limit 10;


-- percentiles 

select 
	percentile_disc(0.25) within group (order by fossil) as p25, --42,65%
	percentile_disc(0.5) within group (order by fossil) as p50, --75,03%
	percentile_disc(0.75) within group (order by fossil) as p75 -- 90,55%
from fossil;

--average fossil fueal usage for countries in time interval
select avg(fossil) mean_fossfuel_usage from fossil -- 65,01% 

-- yearly change for countries (GDP join fossil table)

select * from fossil f
join helper_table ht on ht.shortname = f.shortname
where shortname in ('China', 'United States', 'India', 'Japan', 'Germany') 
	and "Year" < 2013
order by "Year" desc, 
          fossil desc;

--GDP and percentage of fossil fuel usage correlation

with temp_table as (
select * from fossil f 
where shortname in ('China', 'United States', 'India', 'Japan', 'Germany') 
	and "Year" < 2013
order by "Year" desc, 
	fossil desc)
select round(corr(p.pkb , p3.fossil)::numeric,2) 
from temp_table tt
join helper_table ht on ht.shortname = tt.shortname
where tt."Year"=ht."Year";