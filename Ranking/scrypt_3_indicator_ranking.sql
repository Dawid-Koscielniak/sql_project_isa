--POINTS SUMMARY
create table final_ranking as (
select 
	dense_rank() over (order by dg.points + de.points + du.points + dh.points + dt.points desc) as placement,
	dg.shortname as country,
	dg.ranga as GDP_place,
	dg.points as points_GDP,
	de.ranga as education_place,
	de.points as points_education,
	du.ranga as unemplyment_place,
	du.points as points_unemployment,
	dh.ranga as health_place,
	dh.points as points_health,
	dt.ranga as tourism_place,
	dt.points as points_tourism,
	dg.points + de.points + du.points + dh.points + dt.points as points_total
from dev_gdp dg 
join dev_edu de on de.shortname = dg.shortname 
join dev_uemp du on du.shortname = dg.shortname 
join dev_hea dh on dh.shortname = dg.shortname 
join dev_tou dt on dt.shortname = dg.shortname
limit 30);
