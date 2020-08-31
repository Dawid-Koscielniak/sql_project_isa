--Processing data and droping useless (for founded analysis) data

with countries as (
select * from country c2
where 
	alpha2code not similar to '%\d%' and 
	alpha2code not ilike 'X_' and 
	alpha2code not ilike 'oe' and 
	alpha2code not ilike 'Z_')
select * from indicators i
join countries as c on c.countrycode =  i.countrycode
where i."Year" > 1990;

--Selection of NON countries

select 
	countrycode, 
	shortname, 
	currencyunit,
	alpha2code 
from country
where currencyunit = ''

-- Selection ONLY countries (based on currency unit - if there is none it is not a country)

select 
	countrycode,
 	shortname, 
	currencyunit,
	alpha2code 
from country
where currencyunit != ''