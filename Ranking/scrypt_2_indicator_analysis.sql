--COUNTRY RANKING IN RELATION TO SELECTED INDICATORS
--(Due to limited data the time interval is between 1995 and 2013 (inclusive))
--Every country receives points in categories (indicators); summed points will be used to create a ranking
--which purpose is to describe life quality gain in the time interval

--WELTH - Main indicator in this statement to which the rest is related

create table gdp_alt as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value", 
 	lag("Year") over (partition by shortname order by "Year") as previous_year, 
 	round(lag("value") over (partition by shortname order by "Year"),2) as previous_value, 
 	round((("value" - (lag("value") over (partition by shortname order by "Year")))/(2013-1995)),2) as mean_year_gain
from bazafin b
where indicatorname = 'GDP per capita, PPP (current international $)'
	and "Year" in (1995, 2013));

create table dev_gdp as (select 
 	shortname , 
 	mean_year_gain, 
 	dense_rank() over (order by sredni_roczny_przyrost desc) as ranga ,
 	case 
 		when dense_rank() over (order by mean_year_gain desc) = 1 then 55 
		when dense_rank() over (order by mean_year_gain desc) = 2 then 50
		when dense_rank() over (order by mean_year_gain desc) = 3 then 45
		when dense_rank() over (order by mean_year_gain desc) = 4 then 40
		when dense_rank() over (order by mean_year_gaint desc) = 5 then 35
		when dense_rank() over (order by mean_year_gain desc) = 6 then 30
		when dense_rank() over (order by mean_year_gaint desc) = 7 then 25
		when dense_rank() over (order by mean_year_gain desc) = 8 then 20
		when dense_rank() over (order by mean_year_gain desc) = 9 then 15
		when dense_rank() over (order by mean_year_gain desc) = 10 then 10
		when dense_rank() over (order by mean_year_gain desc) > 10
			and dense_rank() over (order by mean_year_gain desc) <= 20 
		then 5
		when dense_rank() over (order by mean_year_gain desc) >= 21
			and dense_rank() over (order by mean_year_gain desc) <= 30
		then 1
	else 0
 end as points
from gdp_alt
where mean_year_gain is not null
limit 50);

--EDUCATION:
create table edu_alt as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value", 
 	lag("Year") over (partition by shortname order by "Year") as previous_year, 
 	round(lag("value") over (partition by shortname order by "Year"),2) as previous_value, 
 	round((("value" - (lag("value") over (partition by shortname order by "Year")))/(2013-1995)),2) as mean_year_gain
from bazafin b
where indicatorname = 'Adjusted savings: education expenditure (current US$)'
	and "Year" in (1995, 2013));

create table dev_edu as (
select 
 	ea.shortname , 
 	ea.mean_year_gain , 
 	dense_rank() over (order by ea.mean_year_gain desc) as ranga ,
 	case 
 		when dense_rank() over (order by ea.mean_year_gain desc) = 1 then 55 
		when dense_rank() over (order by ea.mean_year_gain desc) = 2 then 50
		when dense_rank() over (order by ea.mean_year_gain desc) = 3 then 45
		when dense_rank() over (order by ea.mean_year_gain desc) = 4 then 40
		when dense_rank() over (order by ea.mean_year_gain desc) = 5 then 35
		when dense_rank() over (order by ea.mean_year_gain desc) = 6 then 30
		when dense_rank() over (order by ea.mean_year_gain desc) = 7 then 25
		when dense_rank() over (order by ea.mean_year_gain desc) = 8 then 20
		when dense_rank() over (order by ea.mean_year_gain desc) = 9 then 15
		when dense_rank() over (order by ea.mean_year_gain desc) = 10 then 10
		when dense_rank() over (order by ea.mean_year_gain desc) > 10
			and dense_rank() over (order by ea.mean_year_gaint desc) <= 20 
		then 5
		when dense_rank() over (order by ea.mean_year_gain desc) >= 21
			and dense_rank() over (order by ea.mean_year_gain desc) <= 30
		then 1
	else 0
 end as points
from edu_alt ea
inner join dev_gdp dgdp on dgdp.shortname = ea.shortname
where ea.mean_year_gain is not null);

--EMPLOYMENT (negative values mean falling unemployment):
create table uemp_alt as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value", 
 	lag("Year") over (partition by shortname order by "Year") as previous_year, 
 	round(lag("value") over (partition by shortname order by "Year"),2) as previous_value, 
 	round((("value" - (lag("value") over (partition by shortname order by "Year")))/(2013-1995)),2) as mean_year_gain
from bazafin b
where indicatorname = 'Unemployment, total (% of total labor force)'
	and "Year" in (1995, 2013));

create table dev_uemp as (
select 
 	ua.shortname , 
 	za.mean_year_gain , 
 	dense_rank() over (order by za.mean_year_gain) as ranga ,
 	case 
 		when dense_rank() over (order by ua.mean_year_gain) = 1 then 55 
		when dense_rank() over (order by ua.mean_year_gain) = 2 then 50
		when dense_rank() over (order by ua.mean_year_gain) = 3 then 45
		when dense_rank() over (order by ua.mean_year_gain) = 4 then 40
		when dense_rank() over (order by ua.mean_year_gain) = 5 then 35
		when dense_rank() over (order by ua.mean_year_gain) = 6 then 30
		when dense_rank() over (order by ua.mean_year_gain) = 7 then 25
		when dense_rank() over (order by ua.mean_year_gain) = 8 then 20
		when dense_rank() over (order by ua.mean_year_gain) = 9 then 15
		when dense_rank() over (order by ua.mean_year_gain) = 10 then 10
		when dense_rank() over (order by ua.mean_year_gain) > 10
			and dense_rank() over (order by ua.mean_year_gain desc) <= 20 
		then 5
		when dense_rank() over (order by ua.mean_year_gain desc) >= 21
			and dense_rank() over (order by ua.mean_year_gain desc) <= 30
		then 1
	else 0
 end as points
from uemp_alt ua
inner join dev_gdp dgdp on dgdp.shortname = ua.shortname
where ua.mean_year_gain is not null);

 --HEALTH:
create table hea_alt as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value", 
 	lag("Year") over (partition by shortname order by "Year") as previous_year, 
 	round(lag("value") over (partition by shortname order by "Year"),2) as previous_value, 
 	round((("value" - (lag("value") over (partition by shortname order by "Year")))/(2013-1995)),2) as mean_year_gain
from bazafin b
where indicatorname = 'Health expenditure, public (% of government expenditure)'
	and "Year" in (1995, 2013));

create table dev_hea as (
select 
 	ha.shortname , 
 	ha.mean_year_gain , 
 	dense_rank() over (order by ha.mean_year_gain desc) as ranga ,
 	case 
 		when dense_rank() over (order by ha.mean_year_gain desc) = 1 then 55 
		when dense_rank() over (order by ha.mean_year_gain desc) = 2 then 50
		when dense_rank() over (order by ha.mean_year_gain desc) = 3 then 45
		when dense_rank() over (order by ha.mean_year_gaint desc) = 4 then 40
		when dense_rank() over (order by ha.mean_year_gain desc) = 5 then 35
		when dense_rank() over (order by ha.mean_year_gain desc) = 6 then 30
		when dense_rank() over (order by ha.mean_year_gain desc) = 7 then 25
		when dense_rank() over (order by ha.mean_year_gain desc) = 8 then 20
		when dense_rank() over (order by ha.mean_year_gaint desc) = 9 then 15
		when dense_rank() over (order by ha.mean_year_gain desc) = 10 then 10
		when dense_rank() over (order by ha.mean_year_gain desc) > 10
			and dense_rank() over (order by ha.mean_year_gain desc) <= 20 
		then 5
		when dense_rank() over (order by ha.mean_year_gain desc) >= 21
			and dense_rank() over (order by ha.mean_year_gain desc) <= 30
		then 1
	else 0
 end as points
from hea_alt ha
inner join dev_gdp dgdp on dgdp.shortname = ha.shortname
where ha.mean_year_gain is not null);
 
--TOURISM
-- International tourism, number of arrivals <- 1995-2013
create table tou_alt as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value", 
 	lag("Year") over (partition by shortname order by "Year") as previous_year, 
 	round(lag("value") over (partition by shortname order by "Year"),2) as previous_value, 
 	round((("value" - (lag("value") over (partition by shortname order by "Year")))/(2013-1995)),2) as mean_year_gain
from bazafin b
where indicatorname = 'International tourism, number of arrivals'
	and "Year" in (1995, 2013));

create table dev_tou as (
select 
 	ta.shortname , 
 	ta.mean_year_gain , 
 	dense_rank() over (order by ta.sredni_roczny_przyrost desc) as ranga ,
 	case 
 		when dense_rank() over (order by ta.mean_year_gain desc) = 1 then 55 
		when dense_rank() over (order by ta.mean_year_gain desc) = 2 then 50
		when dense_rank() over (order by ta.mean_year_gain desc) = 3 then 45
		when dense_rank() over (order by ta.mean_year_gain desc) = 4 then 40
		when dense_rank() over (order by ta.mean_year_gain desc) = 5 then 35
		when dense_rank() over (order by ta.mean_year_gain desc) = 6 then 30
		when dense_rank() over (order by ta.mean_year_gain desc) = 7 then 25
		when dense_rank() over (order by ta.mean_year_gaint desc) = 8 then 20
		when dense_rank() over (order by ta.mean_year_gaint desc) = 9 then 15
		when dense_rank() over (order by ta.mean_year_gain desc) = 10 then 10
		when dense_rank() over (order by ta.mean_year_gain desc) > 10
			and dense_rank() over (order by ta.mean_year_gain desc) <= 20 
		then 5
		when dense_rank() over (order by ta.mean_year_gain desc) >= 21
			and dense_rank() over (order by ta.mean_year_gain desc) <= 30
		then 1
	else 0
 end as points
from tou_alt ta
inner join dev_gdp dgdp on dgdp.shortname = ta.shortname
where ta.mean_year_gain is not null);