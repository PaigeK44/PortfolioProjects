/*
Covid-19 Data Exploration

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


SELECT *
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4


--Select data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2


-- Total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location LIKE '%state%'
AND continent IS NOT NULL
ORDER BY 1,2


-- Total cases vs population
-- Shows what percentage of population is infected with Covid

SELECT Location, date, Population, total_cases, (Total_cases/population)*100 AS InfectionRate
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
AND location LIKE '%state%'
ORDER BY 1,2


-- Countries with highest infection rate compared to population

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((Total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC


-- Countries with highest death count per population

SELECT Location, MAX(cast(Total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC


----- Breaking data down by continent -----


-- Continents with the highest death count per population

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


-- Total population vs vaccinations
-- Percentage of population that has recieved at least one Covid-19 vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


-- Using CTE to perform calculation on partition by in previous query

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac


-- Temp table to perform calculation on partition by in previous query

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
	AND dea.date = vac.date
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
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
