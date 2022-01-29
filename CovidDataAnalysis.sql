SELECT *
FROM PortfolioProject1..CovidDeaths
ORDER by 3,4

--SELECT *
--FROM PortfolioProject1..CovidVaccinations
--ORDER by 3,4

-- dalta mnga aga data khawakhao kam che ba mnga karao
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject1..CovidDeaths
ORDER by 1,2

--  total cases vs total deaths percentage
SELECT Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject1..CovidDeaths
Where location like '%Pakistan%'
ORDER by 1,2

--  total cases vs population percentage of pakistan
SELECT Location, date, total_cases,population, (total_cases/population)*100 as CasesPercentage
FROM PortfolioProject1..CovidDeaths
Where location like '%Pakistan%'
ORDER by 1,2

-- mulk kam ke che beramo shara sewa da
SELECT Location, MAX (total_cases) as HighlestInfection, Max ((total_cases/population))*100 as CasesPercentage
FROM PortfolioProject1..CovidDeaths
where continent is not null
Group by location,population
ORDER by CasesPercentage desc

-- Countries ordered by high number of fatalties(tolo k zyad marri chrta shave)

SELECT Location, MAX (cast (total_deaths as int)) as HighestDeaths
FROM PortfolioProject1..CovidDeaths
where continent is not null
Group by location
ORDER by HighestDeaths desc

-- Continents ordered by high number of fatalties(us ye pa bari azam bnd goro)

SELECT continent, sum (cast (total_deaths as int)) as HighestDeaths
FROM PortfolioProject1..CovidDeaths
where continent is not null
Group by continent
ORDER by HighestDeaths desc

-- Eagle view (Global stats i.e total cases,deaths and their %age)

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
where continent is not null 
order by 1,2

-- Analyzing the vaccination of people(total number of vaccinated in a country)

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- Creating view so we can use data later in visualizations

Create View PercentPopulationVaccinated2 as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


-- %age of population who received vaccine(Using CTE(Common Table expression also know as with query))
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentageVccinated
From PopvsVac

-- Performing the same analysis using Temp Table

DROP Table if exists #PercentPopulationVaccinated -- This is needed to drop the table previously created so that we query can creat a new one.
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated

From PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

Select *, (RollingPeopleVaccinated/Population)*100 as PercentageVccinated
From #PercentPopulationVaccinated


