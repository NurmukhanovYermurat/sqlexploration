select * from covid.CovidDeaths
where continent is not null
order by 3,4;

select location, date, total_cases, new_cases,total_deaths,population from covid.CovidDeaths
where continent is not null
order by 1,2;

select location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as death_percentage from covid.CovidDeaths
where location like '%kazakhstan%'
and continent is not null;

select location, date, total_cases,  population, (total_cases/population)*100 as covid_percentage from covid.CovidDeaths
where location like '%kazakhstan%'
and continent is not null;

select location,population, MAX(total_cases) as highest_infaction_rate, MAX((total_cases/population))*100 as highest_covid_infected  from covid.CovidDeaths
group by location, population
order by highest_covid_infected desc;

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases) *100 as DeathPercentage
From covid.CovidDeaths
where continent is not null
order by 1,2

select location, MAX(total_deaths) as Total_deaths from covid.CovidDeaths
where continent is not null
group by location
order by Total_deaths desc;

select location, MAX(total_deaths) as Total_deaths from covid.CovidDeaths
where continent is null
group by location
order by Total_deaths desc;

select date, sum(new_cases) as total_cases,sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as death_percentage from covid.CovidDeaths
where continent is not null
group by date
order by 1,2

With cte (continent, location, date, population,vaccinations,sum_of_vaccinations)
as
(
select dth.continent, dth.location, dth.date, dth.population, vac.C17 as vaccinations, sum(vac.C17) over (partition by dth.location order by dth.location,dth.date) as sum_of_vaccinations
from covid.CovidDeaths dth
join covid.CovidVaccinations vac
    on dth.location = vac.C3
    and dth.date = vac.C4
where dth.continent is not null
/*where location like '%Kazakhstan%'*/
)
select *, (sum_of_vaccinations/population)*100 as percentage_of_vaccinated_people from cte;
########temp table
drop table if exists covid.population_percentage_of_vaccinated
create table covid.population_percentage_of_vaccinated
(
    continent nvarchar(255),
    location nvarchar(255),
    date datetime,
    population numeric,
    new_vaccinations numeric,
    sum_of_vaccinations numeric
)
insert into covid.population_percentage_of_vaccinated
select dth.continent, dth.location, STR_TO_DATE(dth.date, '%m/%d/%Y') AS date, dth.population, vac.C17 as vaccinations, sum(vac.C17) over (partition by dth.location order by dth.location,dth.date) as sum_of_vaccinations
from covid.CovidDeaths dth
join covid.CovidVaccinations vac
    on dth.location = vac.C3
    and dth.date = vac.C4

select *, (sum_of_vaccinations/population) from covid.population_percentage_of_vaccinated

create view covid.population_percentage_of_vaccinated_vr as
    select dth.continent, dth.location, STR_TO_DATE(dth.date, '%m/%d/%Y') AS date, dth.population, vac.C17 as vaccinations, sum(vac.C17) over (partition by dth.location order by dth.location,dth.date) as sum_of_vaccinations
from covid.CovidDeaths dth
join covid.CovidVaccinations vac
    on dth.location = vac.C3
    and dth.date = vac.C4
where dth.location is not null;

select * from covid.population_percentage_of_vaccinated_vr




