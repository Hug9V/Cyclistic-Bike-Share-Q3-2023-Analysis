Select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,5

-- Select Data that we are going to be starting with
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,3
 
 --Total cases over total deaths
Select Location, date, total_cases,total_deaths, 
(total_deaths / total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%states%'

--Total cases over population
Select Location, date, population, total_cases, 
(total_cases / population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%states%'

--Total deaths over population
Select Location, date, population, total_deaths,
(total_deaths / population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%states%'

--Countries with Highest Infection Rate compared to Population
SET ARITHABORT OFF
SET ANSI_WARNINGS OFF
Select Location, Population, MAX(total_cases) as HighestInfectionCount,
MAX((total_cases/population)*100) as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
Order by PercentPopulationInfected Desc

-- Countries with Highest Death Count per Population
Select Location, MAX(Total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent!= ' '
Group by location
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population
Select location, MAX(Total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent = ' ' 
Group by location
order by TotalDeathCount desc

-- GLOBAL NUMBERS
--death percentage by date
Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths,
SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent!= ' ' 
Group By date
ORDER BY 3,4

--Total cases and deaths in the world
Select SUM(cast(new_cases as int)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent!= ' '

--making sure the covidvaccination table was imported correctly
SELECT*
FROM PortfolioProject..CovidVaccinations

--making sure tables were join correctly
SELECT*
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent!= '' 
order by 2,3

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent!=' ' 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac
order by 2,3

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent!= ' ' 

Select *, (RollingPeopleVaccinated)/(Population)*100 as percentage 
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent!=' ' 

SELECT*
FROM PercentPopulationVaccinated

Create View HighestDeathCountbyContinent as
Select location, MAX(Total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent = ' ' 
Group by location

--To see the View table
SELECT *
FROM HighestDeathCountbyContinent
ORDER BY TotalDeathCount desc

Create view InfectionPercentagebyCountry as
Select Location, date, population, total_cases, 
(total_cases / population)*100 as InfectionPercentage
From PortfolioProject..CovidDeaths
where location like '%states%'

SELECT *
FROM InfectionPercentagebyCountry

create View DeathPercentagebyCountry as
Select Location, date, population, total_deaths,
(total_deaths / population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%states%'

SELECT*
FROM DeathPercentagebyCountry

CREATE view WorldwideTotalCasesandDeaths as
Select SUM(cast(new_cases as int)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent!= ' '

SELECT*
FROM WorldwideTotalCasesandDeaths