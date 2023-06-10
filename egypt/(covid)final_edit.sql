select *
from covid_cases
order by location,date
                                          

-------explore death_persentage ----------------------------------------------------
select location,date,total_cases,total_deaths,

COALESCE(total_deaths / NULLIF(total_cases,0), null) death_persentage
FROM [covid_cases]


update  [covid_cases] 
set ---total_deaths =COALESCE(nullif(total_deaths,0),null)
male_smokers=COALESCE(nullif(male_smokers,0),null),
female_smokers=COALESCE(nullif(female_smokers,0),null) ,
total_cases=COALESCE(nullif(total_cases,0),null)


--------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------- Africa_2020 to 5/5/2023---------------------------------------------------------
----africa cases 
create  table  cases_in_africa  
(
country nvarchar (255) ,

T_country_cases float,
T_country_deaths float ,
M_smokers_persentage float ,
F_smokers_persentage float  ,
population int ,
)

insert into cases_in_africa
select 
location as country, 
max(total_cases)T_country_cases,
max(total_deaths) T_country_deaths,
AVG (male_smokers)M_smokers_persentage,
avg (female_smokers)F_smokers_persentage,
population

from covid_cases 


where continent ='Africa' 
group by continent , population ,location
order by location
---------------------------------------update----
update cases_in_africa
set M_smokers_persentage=  FORMAT(M_smokers_persentage,'0.00') ,
  F_smokers_persentage  =  FORMAT(F_smokers_persentage,'0.00')
  

  ---------------------------------------------
select
country,population,
T_country_cases,
T_country_deaths,
(T_country_cases /population)*100 case_persentage_by_popu,
(T_country_deaths/population)*100 death_persentage_by_popu,
( T_country_deaths/T_country_cases)*100 death_persentage_by_cases
from 
cases_in_africa
group by population,T_country_cases,M_smokers_persentage,M_smokers_persentage,T_country_deaths,F_smokers_persentage,country
order by country 

---------------Vaccinations IN Africa---------------------------------------------------------------------------------------------
create table Vaccinations_in_Africa
(
country nvarchar (255) ,
population int ,
vaccinations_available float ,
people_vaccinated float ,
peo_fully_vaccinated float,
 
 median_age float ,
aged_65_older float
)

insert into Vaccinations_in_Africa
select location as country,
population ,
max(total_vaccinations)vaccinations_available ,
max(people_vaccinated )people_vaccinated ,
max(people_fully_vaccinated)peo_fully_vaccinated ,
AVG( median_age )median_age ,
avg (aged_65_older ) aged_65_older

from covid_vac
where continent = 'Africa'
group by location ,population
order by location

-----------------------update ------------------------
update   Vaccinations_in_Africa
set   median_age = FORMAT(median_age,'0.00') ,
aged_65_older = format (aged_65_older ,'0.00')
------------------------------------------------------------

SELECT 
*,
format((people_vaccinated/vaccinations_available)*100  ,'0.00' )     percentage_of_peo_vac_by_totalvac , 
FORMAT((people_vaccinated /population)*100 ,'0.00')               percentage_of_peo_vac_by_popu ,
format((peo_fully_vaccinated /population)*100,'0.00')             percentage_of_peo_fully_vac 
from Vaccinations_in_Africa


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------create viwe as africa covid statistics  by Joining the two tables africa_countries_cases & Vaccinations_IN_Africa------------------------------------------------------------------
create view africa_covid_statistics as
select
cas.country,cas.population,
T_country_cases,
M_smokers_persentage,
F_smokers_persentage,
median_age ,
aged_65_older,
T_country_deaths,
(T_country_cases /cas.population)*100 case_persentage_by_popu,
(T_country_deaths/cas.population)*100 death_persentage_by_popu,
( T_country_deaths/T_country_cases)*100 death_persentage_by_cases,
vaccinations_available ,
people_vaccinated ,
peo_fully_vaccinated,
format((people_vaccinated/vaccinations_available)*100  ,'0.00' )     percentage_of_peo_vac_by_totalvac , 
FORMAT((people_vaccinated /vac.population)*100 ,'0.00')               percentage_of_peo_vac_by_popu ,
format((peo_fully_vaccinated /vac.population)*100,'0.00')             percentage_of_peo_fully_vac 

from
cases_in_africa cas
join Vaccinations_in_Africa vac
on cas.country = vac.country
and cas.population =vac.population

----done----
-------------------------------------------------------Europe-2020 to 5/5/2023------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
------cases in Europe
create  table  cases_in_Europe 
(
country nvarchar (255) ,

T_country_cases float,
T_country_deaths float ,
M_smokers_persentage float ,
F_smokers_persentage float  ,
population int ,
)
insert into cases_in_Europe
select 
location as country, 
max(total_cases)T_country_cases,
max(total_deaths) T_country_deaths,
AVG (male_smokers)M_smokers_persentage,
avg (female_smokers)F_smokers_persentage,
population
from covid_cases 
where continent ='Europe' 
group by continent , population ,location
order by location

---------------------------------------update----
update cases_in_Europe 
set M_smokers_persentage=  FORMAT(M_smokers_persentage,'0.00') ,
  F_smokers_persentage  =  FORMAT(F_smokers_persentage,'0.00')
  -----------------------------------------------------------------------------------------------------
--------------------------Vaccinations IN Europe ---------------------------------------------------------------------------------------------
---------------Vaccinations--------------------------------------------------------------------------------------------
create table Vaccinations_IN_Europe
(
country nvarchar (255) ,
population int ,
vaccinations_available float ,
people_vaccinated float ,
peo_fully_vaccinated float,
 
 median_age float ,
aged_65_older float
)

insert into Vaccinations_IN_Europe
select location as country,
population ,
max(total_vaccinations)vaccinations_available ,
max(people_vaccinated )people_vaccinated ,
max(people_fully_vaccinated)peo_fully_vaccinated ,
AVG( median_age )median_age ,
avg (aged_65_older ) aged_65_older

from covid_vac
where continent = 'Europe'
group by location ,population
order by location

-----------------------update ------------------------
update   Vaccinations_IN_Europe
set   median_age = FORMAT(median_age,'0.00') ,
aged_65_older = format (aged_65_older ,'0.00')
------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------create viwe as Europe covid statistics  by Joining the two tables cases_in_Europe & Vaccinations_IN_Europe------------------------------------------------------------------
create view Europe_covid_statistics as
select
cas.country,cas.population,
T_country_cases,
M_smokers_persentage,
F_smokers_persentage,
median_age ,
aged_65_older,
T_country_deaths,
format((T_country_cases /cas.population)*100,'0.00') case_persentage_by_popu,
format((T_country_deaths/cas.population)*100,'0.00') death_persentage_by_popu,
format(( T_country_deaths/T_country_cases)*100,'0.00') death_persentage_by_cases,
vaccinations_available ,
people_vaccinated ,
peo_fully_vaccinated,
format((people_vaccinated/vaccinations_available)*100  ,'0.00' )     percentage_of_peo_vac_by_totalvac , 
FORMAT((people_vaccinated /vac.population)*100 ,'0.00')               percentage_of_peo_vac_by_popu ,
format((peo_fully_vaccinated /vac.population)*100,'0.00')             percentage_of_peo_fully_vac 

from
cases_in_Europe cas
join Vaccinations_IN_Europe vac
on cas.country = vac.country
and cas.population =vac.population
-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------Asia-2020 to 5/5/2023-----------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
------cases in Asia
create  table  cases_in_Asia
(
country nvarchar (255) ,

T_country_cases float,
T_country_deaths float ,
M_smokers_persentage float ,
F_smokers_persentage float  ,
population int ,
)
insert into cases_in_Asia
select 
location as country, 
max(total_cases)T_country_cases,
max(total_deaths) T_country_deaths,
AVG (male_smokers)M_smokers_persentage,
avg (female_smokers)F_smokers_persentage,
population
from covid_cases 
where continent ='Asia' 
group by continent , population ,location
order by location

---------------------------------------update----
update cases_in_Asia 
set M_smokers_persentage=  FORMAT(M_smokers_persentage,'0.00') ,
  F_smokers_persentage  =  FORMAT(F_smokers_persentage,'0.00')


  -------------------------------------------------------- --------------------------------------------------
--------------------------Vaccinations IN Asia ---------------------------------------------------------------------------------------------
---------------Vaccinations--------------------------------------------------------------------------------------------
create table Vaccinations_in_Asia
(
country nvarchar (255) ,
population int ,
vaccinations_available float ,
people_vaccinated float ,
peo_fully_vaccinated float,
 
 median_age float ,
aged_65_older float
)

insert into Vaccinations_in_Asia
select location as country,
population ,
max(total_vaccinations)vaccinations_available ,
max(people_vaccinated )people_vaccinated ,
max(people_fully_vaccinated)peo_fully_vaccinated ,
AVG( median_age )median_age ,
avg (aged_65_older ) aged_65_older

from covid_vac
where continent = 'Asia'
group by location ,population
order by location

-----------------------update ------------------------
update   Vaccinations_in_Asia
set   median_age = FORMAT(median_age,'0.00') ,
aged_65_older = format (aged_65_older ,'0.00')
----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------create viwe as Asia covid statistics  by Joining the two tables cases_in_Asia & Vaccinations_in_Asia------------------------------------------------------------------
create view Asia_covid_statistics as
select
cas.country,cas.population,
T_country_cases,
M_smokers_persentage,
F_smokers_persentage,
median_age ,
aged_65_older,
T_country_deaths,
format((T_country_cases /cas.population)*100,'0.00') case_persentage_by_popu,
format((T_country_deaths/cas.population)*100,'0.00') death_persentage_by_popu,
format(( T_country_deaths/T_country_cases)*100,'0.00') death_persentage_by_cases,
vaccinations_available ,
people_vaccinated ,
peo_fully_vaccinated,
format((people_vaccinated/vaccinations_available)*100  ,'0.00' )     percentage_of_peo_vac_by_totalvac , 
FORMAT((people_vaccinated /vac.population)*100 ,'0.00')               percentage_of_peo_vac_by_popu ,
format((peo_fully_vaccinated /vac.population)*100,'0.00')             percentage_of_peo_fully_vac 

from
cases_in_Asia  cas
join Vaccinations_in_Asia vac
on cas.country = vac.country
and cas.population =vac.population
---------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------north_America----------------------------------------------------------------------
----------cases_in_north_America-------------------
create  table cases_in_north_America
(
country nvarchar (255) ,

T_country_cases float,
T_country_deaths float ,
M_smokers_persentage float ,
F_smokers_persentage float  ,
population int ,
)
insert into cases_in_north_America
select 
location as country, 
max(total_cases)T_country_cases,
max(total_deaths) T_country_deaths,
AVG (male_smokers)M_smokers_persentage,
avg (female_smokers)F_smokers_persentage,
population
from covid_cases 
where continent ='North America' 
group by continent , population ,location
order by location

---------------------------------------update----
update cases_in_north_America 
set M_smokers_persentage=  FORMAT(M_smokers_persentage,'0.00') ,
  F_smokers_persentage  =  FORMAT(F_smokers_persentage,'0.00')
  --------------------------------------------------------------------------------
   -------------------------------------------------------- --------------------------------------------------
--------------------------Vaccinations /north_America   ---------------------------------------------------------------------------------------------
---------------Vaccinations--------------------------------------------------------------------------------------------
create table Vaccinations_in_north_America 
(
country nvarchar (255) ,
population int ,
vaccinations_available float ,
people_vaccinated float ,
peo_fully_vaccinated float,
 
 median_age float ,
aged_65_older float
)

insert into Vaccinations_in_north_America 
select location as country,
population ,
max(total_vaccinations)vaccinations_available ,
max(people_vaccinated )people_vaccinated ,
max(people_fully_vaccinated)peo_fully_vaccinated ,
AVG( median_age )median_age ,
avg (aged_65_older ) aged_65_older

from covid_vac
where continent = 'North America '
group by location ,population
order by location

-----------------------update ------------------------
update   Vaccinations_in_north_America 
set   median_age = FORMAT(median_age,'0.00') ,
aged_65_older = format (aged_65_older ,'0.00')
----------------------------------------------------------------------------------

-------------------------------------- Vaccinations_in_north_America/cases_in_north_America ---------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------create viwe as north_America covid statistics  by Joining the two tables cases_in_north_America & Vaccinations_in_north_America------------------------------------------------------------------
create view north_America_covid_statistics as
select
cas.country,cas.population,
T_country_cases,
M_smokers_persentage,
F_smokers_persentage,
median_age ,
aged_65_older,
T_country_deaths,
format((T_country_cases /cas.population)*100,'0.00') case_persentage_by_popu,
format((T_country_deaths/cas.population)*100,'0.00') death_persentage_by_popu,
format(( T_country_deaths/T_country_cases)*100,'0.00') death_persentage_by_cases,
vaccinations_available ,
people_vaccinated ,
peo_fully_vaccinated,
format((people_vaccinated/vaccinations_available)*100  ,'0.00' )     percentage_of_peo_vac_by_totalvac , 
FORMAT((people_vaccinated /vac.population)*100 ,'0.00')               percentage_of_peo_vac_by_popu ,
format((peo_fully_vaccinated /vac.population)*100,'0.00')             percentage_of_peo_fully_vac 

from
cases_in_north_America cas
join Vaccinations_in_north_America vac
on cas.country = vac.country
and cas.population =vac.population

--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------South_America_---------------------------------------------------------------------
----------cases_in_South_America----------_America---------
create  table cases_in_South_America
(
country nvarchar (255) ,

T_country_cases float,
T_country_deaths float ,
M_smokers_persentage float ,
F_smokers_persentage float  ,
population int ,
)
insert into cases_in_South_America
select 
location as country, 
max(total_cases)T_country_cases,
max(total_deaths) T_country_deaths,
AVG (male_smokers)M_smokers_persentage,
avg (female_smokers)F_smokers_persentage,
population
from covid_cases 
where continent ='South America' 
group by continent , population ,location
order by location

---------------------------------------update----
update cases_in_South_America 
set M_smokers_persentage=  FORMAT(M_smokers_persentage,'0.00') ,
  F_smokers_persentage  =  FORMAT(F_smokers_persentage,'0.00')
  --------------------------------------------------------------------------------
   -------------------------------------------------------- --------------------------------------------------
--------------------------Vaccinations /South_America   ---------------------------------------------------------------------------------------------
---------------Vaccinations--------------------------------------------------------------------------------------------
create table Vaccinations_in_South_America
(
country nvarchar (255) ,
population int ,
vaccinations_available float ,
people_vaccinated float ,
peo_fully_vaccinated float,
 
 median_age float ,
aged_65_older float
)

insert into Vaccinations_in_South_America
select location as country,
population ,
max(total_vaccinations)vaccinations_available ,
max(people_vaccinated )people_vaccinated ,
max(people_fully_vaccinated)peo_fully_vaccinated ,
AVG( median_age )median_age ,
avg (aged_65_older ) aged_65_older

from covid_vac
where continent = 'South America '
group by location ,population
order by location

-----------------------update ------------------------
update   Vaccinations_in_South_America
set   median_age = FORMAT(median_age,'0.00') ,
aged_65_older = format (aged_65_older ,'0.00')
----------------------------------------------------------------------------------
----------------------------Vaccinations_in_South_America / cases_in_South_America-------------------------------------
--------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------create viwe as South_America covid statistics  by Joining the two tables cases_in_South_America & Vaccinations_in_South_America--
create view  South_America_covid_statistics as
select
cas.country,cas.population,
T_country_cases,
M_smokers_persentage,
F_smokers_persentage,
median_age ,
aged_65_older,
T_country_deaths,
format((T_country_cases /cas.population)*100,'0.00') case_persentage_by_popu,
format((T_country_deaths/cas.population)*100,'0.00') death_persentage_by_popu,
format(( T_country_deaths/T_country_cases)*100,'0.00') death_persentage_by_cases,
vaccinations_available ,
people_vaccinated ,
peo_fully_vaccinated,
format((people_vaccinated/vaccinations_available)*100  ,'0.00' )     percentage_of_peo_vac_by_totalvac , 
FORMAT((people_vaccinated /vac.population)*100 ,'0.00')               percentage_of_peo_vac_by_popu ,
format((peo_fully_vaccinated /vac.population)*100,'0.00')             percentage_of_peo_fully_vac 

from
cases_in_South_America cas
join Vaccinations_in_South_America vac
on cas.country = vac.country
and cas.population =vac.population
------------------------------------------------------oceania-------------------------------------------------------------
--------------cases_in_oceania----------------------------------------------------------------------------------------
create  table cases_in_oceania
(
country nvarchar (255) ,

T_country_cases float,
T_country_deaths float ,
M_smokers_persentage float ,
F_smokers_persentage float  ,
population int ,
)
insert into cases_in_oceania
select 
location as country, 
max(total_cases)T_country_cases,
max(total_deaths) T_country_deaths,
AVG (male_smokers)M_smokers_persentage,
avg (female_smokers)F_smokers_persentage,
population
from covid_cases 
where continent ='oceania' 
group by continent , population ,location
order by location

---------------------------------------update----
update cases_in_oceania
set M_smokers_persentage=  FORMAT(M_smokers_persentage,'0.00') ,
  F_smokers_persentage  =  FORMAT(F_smokers_persentage,'0.00')
  --------------------------------------------------------------------------------
   -------------------------------------------------------- --------------------------------------------------
--------------------------Vaccinations /oceania   ---------------------------------------------------------------------------------------------
---------------Vaccinations--------------------------------------------------------------------------------------------
create table Vaccinations_in_oceania
(
country nvarchar (255) ,
population int ,
vaccinations_available float ,
people_vaccinated float ,
peo_fully_vaccinated float,
 
 median_age float ,
aged_65_older float
)

insert into Vaccinations_in_oceania
select location as country,
population ,
max(total_vaccinations)vaccinations_available ,
max(people_vaccinated )people_vaccinated ,
max(people_fully_vaccinated)peo_fully_vaccinated ,
AVG( median_age )median_age ,
avg (aged_65_older ) aged_65_older

from covid_vac
where continent = 'oceania '
group by location ,population
order by location

-----------------------update ------------------------
update   Vaccinations_in_oceania
set   median_age = FORMAT(median_age,'0.00') ,
aged_65_older = format (aged_65_older ,'0.00')
----------------------------------------------------------------------------------
----------------------------cases_in_oceania/Vaccinations_in_oceania------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------create viwe as oceania covid statistics  by Joining the two tables cases_in_South_oceania & Vaccinations_in_oceania--
create view  oceania_covid_statistics as
select
cas.country,cas.population,
T_country_cases,
M_smokers_persentage,
F_smokers_persentage,
median_age ,
aged_65_older,
T_country_deaths,
format((T_country_cases /cas.population)*100,'0.00') case_persentage_by_popu,
format((T_country_deaths/cas.population)*100,'0.00') death_persentage_by_popu,
format(( T_country_deaths/T_country_cases)*100,'0.00') death_persentage_by_cases,
vaccinations_available ,
people_vaccinated ,
peo_fully_vaccinated,
format((people_vaccinated/vaccinations_available)*100  ,'0.00' )     percentage_of_peo_vac_by_totalvac , 
FORMAT((people_vaccinated /vac.population)*100 ,'0.00')               percentage_of_peo_vac_by_popu ,
format((peo_fully_vaccinated /vac.population)*100,'0.00')             percentage_of_peo_fully_vac 

from
cases_in_oceania cas
join Vaccinations_in_oceania vac
on cas.country = vac.country
and cas.population =vac.population

-----------------------------------------------------------------------------------------------------------------
--------------------------now we will see my country Egypt -------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
create  table cases_in_Egypt
(
country nvarchar (255) ,
_date date ,
T_country_cases float,
New_cases float ,
T_country_deaths float ,
New_deaths float ,
M_smokers_persentage float ,
F_smokers_persentage float  ,
population int ,
)
insert into cases_in_Egypt
select 
location as country,date as _date  ,
(total_cases)T_country_cases,
new_cases as New_cases,
total_deaths as T_country_deaths,
new_deaths as New_deaths,
male_smokers as M_smokers_persentage,
female_smokers as F_smokers_persentage,
population
from covid_cases 
where location ='Egypt' 
----group by continent , population ,location
order by date


  ----------------------------------------------------------------
  -------------------------------------------- Vaccinations_in_Egypt----------------------------
(---------------------------------------------------------------------------------------------------------------------------------------
  create table Vaccinations_in_Egypt
(
country nvarchar (255) ,
_date date  ,
vaccinations_available float ,
people_vaccinated float ,
peo_fully_vaccinated float,
 
 median_age float ,
aged_65_older float
)

insert into Vaccinations_in_Egypt
select location as country,
date _date,
(total_vaccinations)vaccinations_available ,
(people_vaccinated )people_vaccinated ,
(people_fully_vaccinated)peo_fully_vaccinated ,
( median_age )median_age ,
(aged_65_older ) aged_65_older

from covid_vac
where location = 'Egypt '
--group by location ,population
order by date



-----------------------------------------------------------------------------------------------------------------------
---------creat view for Egypt to visualize it later -------------------------------------------------------
create view covid_in_egypt as
select
cas.country,cas.population,cas._date,
T_country_cases,
New_cases,
M_smokers_persentage,
F_smokers_persentage,
median_age ,
 aged_65_older,
T_country_deaths,
New_deaths,

COALESCE(T_country_cases /NULLIF(cas.population,0),0)*100 case_persentage_by_popu,
COALESCE(T_country_deaths/NULLIF(cas.population,0),0)*100 death_persentage_by_popu,
COALESCE( T_country_deaths/NULLIF(T_country_cases,0),0)*100 death_persentage_by_cases,
vaccinations_available ,
people_vaccinated ,
peo_fully_vaccinated,
COALESCE(people_vaccinated/NULLIF(vaccinations_available,0),0)*100       percentage_of_peo_vac_by_totalvac , 
COALESCE(people_vaccinated /NULLIF(cas.population,0),0)*100               percentage_of_peo_vac_by_popu ,
COALESCE(peo_fully_vaccinated /NULLIF(cas.population,0),0)*100           percentage_of_peo_fully_vac 

from
cases_in_Egypt cas
join Vaccinations_in_Egypt vac
on cas.country = vac.country and
cas._date=vac._date
--------------------------------------------------end---------------------------------------------------------------------------------

