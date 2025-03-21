--SELECT*
--FROM dbo.CovidDeaths
--order by 3, 4

--SELECT*
--FROM dbo.CovidVaccinations
--order by 3, 4

-- Select data that I am going to be using

SELECT Location, date, total_cases, total_deaths, population
FROM dbo.CovidDeaths
Order by 1, 2

--looking at total cases vs total deaths

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location like '%Kingdom'
Order by 1, 2

-- Looking at total cases vs Pop
SELECT Location, date, total_cases, total_deaths, population, (total_cases/population)*100 AS PopPer
FROM [Portfolio Project]..CovidDeaths
WHERE location like '%Kingdom'
Order by 1, 2

--Looking at countries with highest infection rate compared with pop

SELECT Location, population, MAX(total_cases) AS HighestInfCount, MAX(total_cases/population)*100 AS CasePercentages
FROM [Portfolio Project]..CovidDeaths
--WHERE location like '%Kingdom'
GROUP by population, location
Order by CasePercentages DESC

--showing countries with highest death count per pop

SELECT Location, MAX(total_deaths) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
WHERE Continent is not NULL
GROUP by location
Order by TotalDeathCount DESC

--By Continents

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
WHERE Continent is NULL
GROUP by location
Order by TotalDeathCount DESC

--showing continents with high death count

SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
WHERE Continent is not NULL
GROUP by continent
Order by TotalDeathCount DESC

--Global numbers

SELECT sum(new_cases) as TotalNewCases, sum(new_deaths) as TotalNewDeaths,
sum(new_deaths)/sum(new_cases)*100 AS TotalDeathPerc
FROM [Portfolio Project]..CovidDeaths
--WHERE location like '%Kingdom'
Where continent is not null
--Group by date
Order by TotalDeathPerc DESC 

--looking at totalpop vs vaccination
--Use CET
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, CumulativeCountVacc)
as
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS CumulativeCountVacc

FROM [Portfolio Project]..CovidDeaths AS dea
JOIN [Portfolio Project]..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--Order by 2, 3
)
SELECT*, (CumulativeCountVacc/Population)*100 AS PercentageofPopVaccinated
From PopvsVac


-- TEMP 
    DROP TABLE if exists #PercentagePopulationVaccinated;
GO

CREATE TABLE #PercentagePopulationVaccinated
(
    Continent nvarchar(50),
    Location nvarchar(50),
    Date date,
    Population decimal(18, 2),
    New_vaccinations decimal(18, 2),
    CumulativeCountVacc decimal(18, 2) -- ✅ This was missing!
);
GO

INSERT into #PercentagePopulationVaccinated
SELECT dea.continent, dea.location, dea.date, 
    CAST(dea.population AS decimal(18, 2)),          -- Cast here
    CAST(vac.new_vaccinations AS decimal(18, 2)),    -- Cast here
    SUM(CAST(vac.new_vaccinations AS decimal(18, 2))) 
    OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS CumulativeCountVacc

FROM [Portfolio Project]..CovidDeaths AS dea
JOIN [Portfolio Project]..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
--WHERE dea.continent is not null
--Order by 2, 3


SELECT*, (CumulativeCountVacc/Population)*100 AS PercentageofPopVaccinated
From #PercentagePopulationVaccinated

--debugging to find missing column
SELECT 
    COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE
FROM tempdb.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE '#PercentagePopulationVaccinated%';

--drop temp table to recreate

IF OBJECT_ID('tempdb..#PercentagePopulationVaccinated') IS NOT NULL
    DROP TABLE #PercentagePopulationVaccinated;
GO

CREATE TABLE #PercentagePopulationVaccinated
(
    Continent nvarchar(50),
    Location nvarchar(50),
    Date date,
    Population decimal(18, 2),
    New_vaccinations decimal(18, 2),
    CumulativeCountVacc decimal(18, 2) -- ✅ This was missing!
);
GO

--Creating view to store data for later data visualisations

Create view Portfolio.DBO.PercentagePopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS decimal(18, 2))) 
    OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS CumulativeCountVacc

FROM [Portfolio Project]..CovidDeaths AS dea
JOIN [Portfolio Project]..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--Order by 2, 3


SELECT*
FROM master..PercentagePopulationVaccinated