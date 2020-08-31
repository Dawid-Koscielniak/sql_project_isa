--CORRELATION
--checking if there is a correlation between alteration of previously selected indicators and alteration of GDP per capita (yearly)

--GDP per capita
with country_gdp as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'GDP per capita, PPP (current international $)'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

--EDUCATION

country_edu as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'Adjusted savings: education expenditure (current US$)'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

corr_gdp_edu as (
select 
	country_gdp.shortname,
	corr(country_gdp."value", country_edu."value") as correlation_value
from country_gdp
join country_edu on country_gdp.shortname = country_edu.shortname
group by country_gdp.shortname)

select 
	'GDP-Education correlation' as Indicators,
	avg(correlation_value) as mean_correlation_value
from corr_gdp_edu;

--EMPLOYMENT	

with country_gdp as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'GDP per capita, PPP (current international $)'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

country_uemp as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'Unemployment, total (% of total labor force)'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

corr_gdp_uemp as (
select 
	country_gdp.shortname,
	corr(country_gdp."value", country_uemp."value") as correlation_value
from country_gdp
join country_uemp on country_uemp.shortname = country_gdp.shortname
group by country_gdp.shortname)

select 
	'GDP-Unemployment correlation' as Indicators,
	avg(correlation_value) as mean_correlation_value
from corr_gdp_uemp;

--HEALTH

with country_gdp as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'GDP per capita, PPP (current international $)'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

country_hea as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'Health expenditure, public (% of government expenditure)'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

corr_gdp_hea as (
select 
	country_gdp.shortname,
	corr(country_gdp."value", country_hea."value") as correlation_value
from country_gdp
join country_hea on country_hea.shortname = country_gdp.shortname
group by country_gdp.shortname)

select 
	'GDP-Healthcare correlation' as Indicators,
	avg(correlation_value) as mean_correlation_value
from corr_gdp_hea;

--TOURISM

with country_gdp as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'GDP per capita, PPP (current international $)'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

country_tur as (
select 
	shortname , 
	"Year", 
	round("value",2) as "value"
from bazafin b
where indicatorname = 'International tourism, number of arrivals'
	and "Year" >= 1995
	and "Year" <= 2013
order by shortname asc, "Year" asc),

corr_gdp_tur as (
select 
	country_gdp.shortname,
	corr(country_gdp."value", country_tur."value") as korelacja
from country_gdp
join country_tur on country_tur.shortname = country_gdp.shortname
group by country_gdp.shortname)

select 
	'GDP-Tourism correlation' as Indicators,
	avg(correlation_value) as mean_correlation_value
from corr_gdp_tur;
	