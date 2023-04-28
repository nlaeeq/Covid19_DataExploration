/* 
Exploratory Analysis on COVID-19 data
*/

-- Confirming that all of the rows have been uploaded to SQL server from Covid_Deaths spreadsheet

SELECT 
	*
FROM 
	Portfolio_Project.dbo.Covid_Deaths


-- Confirming that all of the rows have been uplaoded to SQL server from Covid_Vaccinations spreadsheet

SELECT 
	*
FROM 
	Portfolio_Project.dbo.Covid_Vaccinations


--Lets start checking with world continents.
--The query shows that there are NULL values present in continent column. This will be taken into condieration throughtout the analysis as this will skew the country data.

SELECT 
	DISTINCT continent  
FROM 
	Portfolio_Project.dbo.Covid_Deaths 


--Arrange the tables according to location & date, and filtering out the null values in continent column bu using 'is not Null operator.

SELECT 
	*
FROM 
	Portfolio_Project.dbo.Covid_Deaths
WHERE 
	continent is not Null
ORDER BY 
	3,
	4

SELECT 
	*
FROM 
	Portfolio_Project.dbo.Covid_Vaccinations
WHERE 
	continent is not Null
ORDER BY 
	3,
	4


--To further explore daily reports on total cases and deaths per country, ordered by location and Date columns for ease of reference.

SELECT 
	location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
FROM 
	Portfolio_Project.dbo.Covid_Deaths
WHERE 
	continent is not NULL
ORDER BY
	1, 
	2


--To understand the impact of the Covid-19 pandemic in each country, the data needs to be aggregated. 
--This query calculates the Total Cases vs Total Deaths for each country and creates a new column called Mortality Rate.

SELECT
	location,
	date,
	total_cases,
	total_deaths,
	(total_deaths/total_cases)*100 AS Mortality_Rate
FROM
	Portfolio_Project.dbo.Covid_Deaths
WHERE 
	continent is not NULL
ORDER BY
	1,
	2 


--To calculate Total Cases VS Population and creating new column Percent population infected.
--This will give the percentage of each country's population which was infected with Covid-19.

SELECT
	location,
	date,
	population,
	total_cases,
	(total_cases/population)*100 AS Percent_Population_Infected
FROM
	Portfolio_Project.dbo.Covid_Deaths
WHERE
	continent is not NULL
ORDER BY
	1,
	2


--To calculate the highest infection count compared to population.
--This query will give the maximum percentage population infected for each country.

SELECT
	location,
	population,
	MAX(total_cases) AS Highest_Infection_Count,
	MAX((total_cases/population))*100 AS Max_Percent_Population_Infected
FROM 
	Portfolio_Project.dbo.Covid_Deaths
WHERE 
	continent is not NULL
GROUP BY
	location, 
	population
ORDER BY 
	Max_Percent_Population_Infected desc


--Calculating Country-wise highest death count with respect to thier population.
--This query gives the mortality count for each country and creates a new column called Total deaths count, order in descending.

SELECT 
	location,
	population,
	MAX(CAST(total_deaths AS int)) AS Total_Deaths_Count
FROM 
	Portfolio_Project.dbo.Covid_Deaths
WHERE 
	continent is not null
GROUP BY 
	location, 
	population
ORDER BY
	Total_Deaths_Count desc


--Calculating Continent-wise total death counts in descending order.
--As the location column contains country names as well as continent names, so we will select only the desired continents.

SELECT location, MAX(CAST(total_deaths AS int)) AS Total_Death_Count
FROM Portfolio_Project.dbo.Covid_Deaths
WHERE location = 'Europe' or location = 'Asia' or location = 'Africa' or location = 'North America' or location = 'South America'
or location = 'Oceania'
GROUP BY location
ORDER BY Total_Death_Count desc


--Calculating World-wide Death Rate

SELECT 
	MAX(CAST(total_cases AS int)) AS Total_World_Cases, 
	MAX(CAST(total_deaths AS int)) AS Total_World_Deaths, 
	CONCAT(ROUND((SUM(new_deaths)/SUM(new_cases))*100,3),'%') AS World_Death_Rate
FROM 
	Portfolio_Project.dbo.Covid_Deaths
WHERE 
	location = 'World'


--In order to do further analysis, we will merge the two tables by using JOIN. The tables will be join on location and date variables.
--For ease of reference, the table Covid_Deaths has been aliased to 'dea' and Covid_Vaccinations has been alised to 'vac' respectively.

SELECT
	*
FROM
	Portfolio_Project.dbo.Covid_Deaths AS dea
JOIN 
	Portfolio_Project.dbo.Covid_Vaccinations AS vac
		ON dea.location = vac.location
		AND dea.date = vac.date


--Now using both of the tables, check number of people vaccinated per population

SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations
FROM
	Portfolio_Project.dbo.Covid_Deaths AS dea
JOIN
	Portfolio_Project.dbo.Covid_Vaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent is not NULL
ORDER BY
	1,
	2,
	3


--Calculating Rolling count of new vaccinations per day, using Partition By clause
--This query will give the accumulated number of daily vaccinations in each country

SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(CAST(new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Accumulated_Daily_Vaccinations
FROM 
	Portfolio_Project.dbo.Covid_Deaths AS dea
JOIN Portfolio_Project.dbo.Covid_Vaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE 
	dea.continent is not Null
ORDER BY 
	2,
	3


--Calculating Country wise Vaccination rate in accordance with their population
--For that purpose we will create TEMP table as we cannot use the column created and reference it in the same query.

DROP TABLE IF EXISTS #Percent_Poulation_Vaccinated
CREATE TABLE #Percent_Poulation_Vaccinated
	( 
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	Accumulated_Daily_Vaccinations numeric
	)


INSERT INTO #Percent_Poulation_Vaccinated
SELECT 
	dea.continent,
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(CAST(new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Accumulated_Daily_Vaccinations
FROM 
	Portfolio_Project.dbo.Covid_Deaths AS dea
JOIN Portfolio_Project.dbo.Covid_Vaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE 
	dea.continent is not Null
ORDER BY 
	2,
	3

SELECT 
	*, 
	(Accumulated_Daily_Vaccinations/Population)*100
FROM 
	#Percent_Poulation_Vaccinated
