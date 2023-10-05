SELECT *
FROM DeathsCovid

--GLOBAL KPI´s
-- DEATHS
SELECT SUM(total_deaths) AS TOTAL_DEATHS
FROM DeathsCovid

SELECT SUM(total_deaths) AS TOTAL_DEATHS
FROM DeathsCovid
WHERE YEAR(date) = 2020

SELECT SUM(total_deaths) AS TOTAL_DEATHS
FROM DeathsCovid
WHERE YEAR(date) = 2021

SELECT date, SUM(total_deaths) AS TOTAL_DEATHS
FROM DeathsCovid
WHERE YEAR(date) = 2022


--CASES
SELECT SUM(total_cases) AS CASES_TOTAL
FROM DeathsCovid

SELECT SUM(total_cases) AS CASES_TOTAL
FROM DeathsCovid
WHERE YEAR(date) = 2020

SELECT SUM(total_cases) AS CASES_TOTAL
FROM DeathsCovid
WHERE YEAR(date) = 2021

SELECT SUM(total_cases) AS CASES_TOTAL
FROM DeathsCovid
WHERE YEAR(date) = 2022

--TOTAL CASES VS POPULATION

SELECT DISTINCT(location),
       --date,
	   population,
	   total_cases,
	   CAST((total_cases/population)*100 AS DECIMAL (10,2))AS CASES_PERCENTAGE
FROM DeathsCovid
GROUP BY location, population, total_cases
ORDER BY CASES_PERCENTAGE DESC

-- PERCENTAGE OF TOTAL NEW CASES AGAINST NEW DEATHS

SELECT date,
       SUM(new_cases) AS cases_new,
	   SUM(new_deaths) AS deaths_new,
	   CAST(SUM(new_deaths)/SUM(new_cases) AS DECIMAL (10,2)) AS PERCENTAGE
FROM DeathsCovid
WHERE new_cases !=0
      AND new_deaths !=0
GROUP BY date
ORDER BY date

--TOP 10 COUNTRIES WITH THE HIGHEST DEATH COUNT VS POPULATION

SELECT TOP 10 (location),
       population,
	   SUM(total_deaths) AS TOTALDEATH_COUNT
FROM DeathsCovid
WHERE continent <> '0'
GROUP BY location, population
ORDER BY TOTALDEATH_COUNT DESC

--TOP 10 COUNTRIES WITH THE HIGHEST INFECTION RATE

SELECT TOP 10 (location),
       population,
	   MAX(total_cases) as HIGHESTINFECTION_COUNT,
	   CAST((MAX(total_cases)/population)*100 AS DECIMAL (10,2)) AS PERC_POPULATIONINFECTED
FROM DeathsCovid
GROUP BY location, population
ORDER BY PERC_POPULATIONINFECTED DESC

--CONTINENT WITH THE HIGHEST DEATH COUNT

SELECT DISTINCT(continent),
       SUM(total_deaths) as TOTALDEATH_COUNT
FROM DeathsCovid
WHERE continent <> '0'
GROUP BY continent
ORDER BY TOTALDEATH_COUNT DESC

--CONTINENT WITH THE HIGHEST INFECTION RATE

SELECT DISTINCT(continent),
       population,
	   MAX(total_cases) as HIGHESTINFECTION_COUNT,
	   CAST((MAX(total_cases)/population)*100 AS DECIMAL (10,2)) AS PERC_POPULATIONINFECTED
FROM DeathsCovid
WHERE continent <> '0'
GROUP BY continent, population, iso_code
ORDER BY PERC_POPULATIONINFECTED DESC

--COUNTRIES IN EUROPE WITH THE HIGHEST INFECTION, INFECTION RATE, DEATH COUNT
-- 1. INFECTION

SELECT TOP 10 (location),
       population,
	   SUM(total_cases) AS TOTAL_INFECTION
FROM DeathsCovid
WHERE continent <> '0'
      AND continent = 'Europe'
GROUP BY location, population
ORDER BY TOTAL_INFECTION DESC

-- 2. INFECTION RATE

SELECT TOP 10 (location),
       population,
	   MAX(total_cases) as HIGHESTINFECTION_COUNT,
	   CAST((MAX(total_cases)/population)*100 AS DECIMAL (10,2)) AS PERC_POPULATIONINFECTED
FROM DeathsCovid
WHERE continent <> '0'
      AND continent = 'Europe'
GROUP BY location, population
ORDER BY PERC_POPULATIONINFECTED DESC

--3. DEATH COUNT

SELECT TOP 10 (location),
       population,
	   SUM(total_deaths) AS TOTALDEATH_COUNT
FROM DeathsCovid
WHERE continent <> '0'
      AND continent = 'Europe'
GROUP BY location, population
ORDER BY TOTALDEATH_COUNT DESC

--VACCINATIONS

SELECT *
FROM VaccinationsCovid

--JOINS DeathsCovid AND VaccinationsCovid

SELECT *
FROM DeathsCovid DC
JOIN VaccinationsCovid VC
   ON DC.location = VC.location
   AND DC.date = VC.date

--POPULATION VS VACCINATION - GLOBALLY

SELECT DC.continent, 
       DC.location,
	   --DC.date,
	   DC.population,
	   SUM(VC.total_vaccinations) AS TOTAL_VACCGIVEN,
	   SUM(VC.people_vaccinated) AS VACCINATED_PEOPLE,
	   SUM(VC.people_fully_vaccinated) AS FULLY_VACC_PEOPLE
FROM DeathsCovid DC
JOIN VaccinationsCovid VC
   ON DC.location = VC.location
   --AND DC.date = VC.date
WHERE DC.continent <> '0'
   --AND YEAR(DC.date) = 2021
GROUP BY DC.continent, 
       DC.location,
	   --DC.date,
	   DC.population
ORDER BY 1,2

--VACCINATIONS BY CONTINENT

SELECT DC.continent, 
       --DC.location,
	   --DC.date,
	   --DC.population,
	   SUM(VC.total_vaccinations) AS TOTAL_VACCGIVEN,
	   SUM(VC.people_vaccinated) AS VACCINATED_PEOPLE,
	   SUM(VC.people_fully_vaccinated) AS FULLY_VACC_PEOPLE
FROM DeathsCovid DC
JOIN VaccinationsCovid VC
   ON DC.location = VC.location
   --AND DC.date = VC.date
WHERE DC.continent <> '0'
   --AND YEAR(DC.date) = 2021
GROUP BY DC.continent 
       --DC.location,
	   --DC.date,
	   --DC.population
ORDER BY 1,2

--TOP 10 VACCINATIONS BY EUROPE

SELECT --DC.continent, 
       DC.location,
	   --DC.date,
	   --DC.population,
	   SUM(VC.total_vaccinations) AS TOTAL_VACCGIVEN,
	   SUM(VC.people_vaccinated) AS VACCINATED_PEOPLE,
	   SUM(VC.people_fully_vaccinated) AS FULLY_VACC_PEOPLE
FROM DeathsCovid DC
JOIN VaccinationsCovid VC
   ON DC.location = VC.location
   --AND DC.date = VC.date
WHERE DC.continent <> '0'
    AND DC.continent = 'Europe'
   --AND YEAR(DC.date) = 2021
GROUP BY --DC.continent 
       DC.location
	   --DC.date,
	   --DC.population
ORDER BY 1,2

--ROLLING PEOPLE VACCINATIONS

SELECT DC.continent, 
       DC.location,
	   DC.date,
	   DC.population,
	   VC.new_vaccinations,
	   SUM(VC.new_vaccinations)
	     OVER (PARTITION BY DC.location
		       ORDER BY DC.location, DC.date) AS RollingPeopleVaccinated
FROM DeathsCovid DC
JOIN VaccinationsCovid VC
   ON DC.location = VC.location
   AND DC.date = VC.date
WHERE DC.continent <> '0'
ORDER BY 2,3

--USE CTE

WITH PopVsVac (continent, location, date, population, new_vaccination, RollingPeopleVaccinated)
  AS
  (
   SELECT DC.continent, 
       DC.location,
	   DC.date,
	   DC.population,
	   VC.new_vaccinations,
	   SUM(VC.new_vaccinations)
	     OVER (PARTITION BY DC.location
		       ORDER BY DC.location, DC.date) AS RollingPeopleVaccinated
  FROM DeathsCovid DC
  JOIN VaccinationsCovid VC
    ON DC.location = VC.location
    AND DC.date = VC.date
  WHERE DC.continent <> '0'
  )
SELECT *,
       CAST((RollingPeopleVaccinated/Population)*100 AS DECIMAL (10,3)) AS PERC_of_RollingPeopleVaccinated
FROM PopVsVac

--OR USE TEMP TABLE

DROP Table if exists #Percent_Population_Vaccinated 
CREATE Table #Percent_Population_Vaccinated
(
  Continent nvarchar(255),
  Location nvarchar(255),
  Date datetime,
  Population numeric,
  New_vaccination numeric,
  RollingPeopleVaccinated numeric
)

INSERT INTO #Percent_Population_Vaccinated
SELECT DC.continent, 
       DC.location,
	   DC.date,
	   DC.population,
	   VC.new_vaccinations,
	   SUM(VC.new_vaccinations)
	     OVER (PARTITION BY DC.location
		       ORDER BY DC.location, DC.date) AS RollingPeopleVaccinated
  FROM DeathsCovid DC
  JOIN VaccinationsCovid VC
    ON DC.location = VC.location
    AND DC.date = VC.date
  WHERE DC.continent <> '0'

SELECT *, 
       CAST((RollingPeopleVaccinated/Population)*100 AS DECIMAL (10,3)) AS PERC_of_RollingPeopleVaccinated
FROM #Percent_Population_Vaccinated

--CREATE VIEW FOR TABLEAU VIZ

CREATE VIEW Percent_Population_Vaccinated AS
   SELECT DC.continent, 
       DC.location,
	   DC.date,
	   DC.population,
	   VC.new_vaccinations,
	   SUM(VC.new_vaccinations)
	     OVER (PARTITION BY DC.location
		       ORDER BY DC.location, DC.date) AS RollingPeopleVaccinated
  FROM DeathsCovid DC
  JOIN VaccinationsCovid VC
    ON DC.location = VC.location
    AND DC.date = VC.date
  WHERE DC.continent <> '0'


  SELECT *
  FROM Percent_Population_Vaccinated