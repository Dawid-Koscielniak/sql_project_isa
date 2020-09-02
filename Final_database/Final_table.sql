-- Creating final table for the analysis

create table bazafin as (
select 
	cnt.countrycode,
 	cnt.shortname,
 	cnt.currencyunit,
 	cnt.alpha2code,
 	i.indicatorname,
 	i.indicatorcode,
 	i.value,
 	i."Year" 
from (
select 
	countrycode,
	shortname,
	currencyunit,
	alpha2code
from country
where currencyunit != '') as cnt
join indicators as i on cnt.countrycode=i.countrycode
where i."Year" > 1989);
