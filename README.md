![](images/cover-photo-1.jpg)

### INTRODUCTION:

The aim of this project is to conduct exploratory analysis on **Covid-19** data using **SQL**. The research has been made in order to estimate the impact of the pandemic on global health and mortality, and to extract some useful insights about vaccinations.

<br>

### DATASET OVERVIEW:

For this project, I have used [**Coronavirus (COVID-19) Deaths**](https://ourworldindata.org/covid-deaths) dataset, which has been published on Our World In Data website, completely open access under the [**Creative Commons BY license**](https://creativecommons.org/licenses/by/4.0/).  This dataset updates on weekly basis and includes values since 3rd January 2020.

**Citation:**

Edouard Mathieu, Hannah Ritchie, Lucas Rodés-Guirao, Cameron Appel, Charlie Giattino, Joe Hasell, Bobbie Macdonald, Saloni Dattani, Diana Beltekian, Esteban Ortiz-Ospina and Max Roser (2020) - "Coronavirus Pandemic (COVID-19)". Published online at OurWorldInData.org. Retrieved from: 'https://ourworldindata.org/coronavirus' [Online Resource]

<br>

### DATA CHARACTERIZATION:

The dataset contains official daily counts of COVID-19 cases and deaths. However, it contains several other attributes as well, but not all of them will be used for this analysis. Data can be segregated into following categories.

•	Case and death count data

•	Vaccination data

•	Population data

•	Public health and social measures data

<br>

### INITIAL WORKING:

This project will examine the worldwide Covid data from **3rd January 2020** to **29th March 2023**. Further I have separated the dataset in two different excel files “Covid_Deaths” and “Covid_Vaccinations” for my analysis purpose.

<br>

### DATA EXPLORATION:

Below is the working that I have done in **SQL Server Management Studio** for data exploration.

<style type="text/css">
  .gist {width:100% !important;}
  .gist-file
  .gist-data {max-height: 500px;max-width: 100%;}
</style>

<script src="https://gist.github.com/nlaeeq/3d7b1844742e7c84193dfe2b3346e713.js"></script>

<br>

### EXPLORATORY ANALYSIS:

The dataset contains daily counts of COVID-19 cases, deaths and vaccine utilization reported by each country. The data is in several rows for each country.

Location should comprised of values referring to that particular country, however, it is found that location column contains entries as World, continent name and income-wise segregation of countries. This needs to be taken in consideration when making country-wise comparisons.

There are Null values present in Continent column besides continent specific entries.

In some case while performing calculation, the data type of the variable has to be casted to the desired type.

There are few countries for which data is not available and therefore contain null values.

<br>

### NEXT AGENDA:

The next segment of this project is to [**clean the dataset**](https://nlaeeq.github.io/Covid19_DataCleaning/) for any possible inaccuracies and inconsistencies. 

<br><br>

**Thank you for reading this project.**
