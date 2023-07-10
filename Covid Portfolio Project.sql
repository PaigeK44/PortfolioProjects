
SELECT *
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject.dbo.CovidVaccinations
--ORDER BY 3,4


--Select Data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
and location like '%state%'
ORDER BY 1,2



-- Looking at the Total Cases vs Population
-- Shows what percentage of population got Covid

SELECT Location, date, Population, total_cases, (Total_cases/population)*100 AS InfectionRate
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
and location like '%state%'
ORDER BY 1,2


-- Looking at Countries with Highest Infection Rate compared to Population
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((Total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC


--Showing Countries with Highest Death Count per Population
SELECT Location, MAX(cast(Total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC


-- Showing continents with the highest death count per population

SELECT continent, MAX(cast(Total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- Global numbers

SELECT SUM(new_cases) AS Total_cases, SUM(cast(new_deaths as int)) AS Total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2



-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


-- Use CTE

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac



-- Temp Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated


--Creating view to store data for later vizualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL


SELECT *
FROM PercentPopulationVaccinated
ORDER BY 2,3