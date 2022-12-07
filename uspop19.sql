
select *
from uspop19


1, -- counties with the largest area land

select state_name, county_name, area_land

from uspop19

order by area_land desc


2, -- sort counties by longitude from greatest to smallest value

select state_name, county_name, internal_point_lat, internal_point_lon

from uspop19

order by 4 desc


 3, -- 20 counties that had the most birth

select  top 20 state_name, county_name, births_2019

from uspop19

order by births_2019 desc



 4,-- 20 counties with most deaths

 select top 20 state_name, county_name, deaths_2019

 from uspop19

 order by deaths_2019 desc


5,-- calculate natural increase from 2019 US population estimate

select county_name, state_name,births_2019, deaths_2019, births_2019 - deaths_2019 as natural_increase

from uspop19
order by 5 desc


6, -- to calculate the percentage of each area of county made up of water

select state_name, county_name, cast( area_water as numeric) /(area_land+area_water) *100   as pct_water

from uspop19

order by 3 desc

7, -- to calculate the percentage change in population estimate of counties between 2018 and 2019

select state_name, county_name, (pop_est_2019 - pop_est_2018)/ cast(pop_est_2018 as numeric) * 100 as pct_change

from uspop19

order by 3 desc


8,-- calculate the sum, average  and median population estimate of all counties in the USA in 2019

 select sum(pop_est_2019) as total_pop, avg(pop_est_2019) as average_pop

from uspop19



--9, to calculate the median population of all counties in 2019

  select distinct percentile_cont (.5) within group(order by pop_est_2019)  over() as median_pop

  from uspop19



  --10, ratio of births to deaths for each county in new york in 2019

  select county_name,births_2019, deaths_2019, cast (births_2019 as numeric)/deaths_2019 as birth_death_ratio
  from uspop19
  where state_name = 'New York'
  order by birth_death_ratio desc


  -- 11, was the median county population in 2019 higher in newyork or california

  select  distinct state_name, PERCENTILE_CONT(.5) within group(order by pop_est_2019)over(partition by state_name)

  from uspop19
  where state_name in ('New York', 'California')


  -- 12, using joins to get the percentage change in county population using US county population estimate data in 2010 and 2019

  select us19.state_fips, us19.county_fips, us19.county_name,us10.estimates_base_2010,us19.pop_est_2019,
  
 Round( (us19.pop_est_2019  -us10. estimates_base_2010 )/cast( us10.estimates_base_2010 as numeric) *100, 1) as pct_change
 
 from uspop19 us19 join uspop10 us10
 
 on  us19.state_fips = us10.state_fips and us19.county_fips = us10.county_fips

 order by pct_change desc


 --- 13, using a common table expression to get the median percentage change(using pct_change from 12 above)



 with ctep as



( select us19.state_fips, us19.county_fips, us19.county_name,us10.estimates_base_2010,us19.pop_est_2019,
  
 Round( (us19.pop_est_2019  -us10. estimates_base_2010 )/cast( us10.estimates_base_2010 as numeric) *100, 1) as pct_change
 
 from uspop19 us19 join uspop10 us10
 
 on  us19.state_fips = us10.state_fips and us19.county_fips = us10.county_fips

 )


 select distinct PERCENTILE_CONT(.5) within group (order by pct_change) over() as median_pct
 from ctep.



 select state_name, county_name, state_fips, county_fips, '2010' as year

 from uspop19


 union 

 select  state_name, county_name, state_fips, county_fips,'2019' as year

 from uspop10

 order by state_fips
  
