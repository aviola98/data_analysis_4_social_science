#tidy data

library(tidyverse)

#general description
#1-each variable must have its own column
#2-each observation must have its own row
#3-each value must have its own cell

#pivoting

table1 <- tibble(country = c("Afghanistan","Afghanistan","Brazil","Brazil","China","China"),
       year = c(1999,2000,1999,2000,1999,2000),
       cases = c(745,2666,37737,80488,212258,213766),
       population = c(19987071,20595360,172006362,174504898,1272915272,
                      1280428583))

table2 <-  tibble(country = c("Afghanistan","Afghanistan","Afghanistan","Afghanistan","Brazil","Brazil"),
                  year = c(1999,1999,2000,2000,1999,1999),
                  type = c("cases","population","cases","population","cases","population"),
                  count = c(745,19987071,2666,20595360,37737,172006362))


table3 <- tibble(country = c("Afghanistan","Afghanistan","Brazil","Brazil","China","China"),
                 year = c(1999,2000,1999,2000,1999,2000),
                 cases = c(745,2666,37737,80488,212258,213766),
                 rate = c(745/19987071,
                          2666/20595360,
                          37737/172006362,
                          80488/174504898,
                          212258/1272915272,
                          213766/1280428583))

table4a <- tibble(country = c("Afghanistan","Brazil","China"),
                  `1999`=c(745,37737,212258),
                  `2000`=c(2666,80488,213766))

table4b <- tibble(country = c("Afghanistan","Brazil","China"),
                  `1999`=c(19987071,172006362,1272915272),
                  `2000`=c(20595360,174504898,1280428583))


#examples

#compute rate per 10.000

table1 %>%
  mutate(rate = cases / population*10000)

#compute cases per year

table1 %>%
  count(year,wt=cases)

#visualize changes over time

library(ggplot2)

ggplot(table1, aes(year,cases)) +
  geom_line(aes(group = country),colour = "grey50") +
  geom_point(aes(colour=country))

#Compute the rate for table2, and table4a + table4b. You will need to perform four operations:
#To calculate cases per person, we need to divide cases by population for each country and year. This is easiest if the cases and population variables are two columns in a data frame in which rows represent (country, year) combinations.

#Table 2: First, create separate tables for cases and population and ensure that they are sorted in the same order.

t2_cases <- filter(table2, type == "cases") %>%
  rename(cases = count) %>%
  arrange(country,year)

t2_population <- filter(table2, type == "population") %>%
  rename(population = count) %>%
  arrange(country,year)
#then create a new data frame with the population and case columns,and calculate cases per capite in a new column

t2_cases_per_cap <- tibble(
  year = t2_cases$year,
  country = t2_cases$country,
  cases = t2_cases$cases,
  population = t2_population$population) %>%
  mutate(cases_per_cap = (cases / population) * 10000) %>%
  select(country, year, cases_per_cap)

#to store this new table in the appropriate location we'll need to store this new variable
#in the appropriate location, we'll add new rows to column 2

t2_cases_per_cap <- t2_cases_per_cap %>%
  mutate(type="cases_per_cap") %>%
  rename(count=cases_per_cap)

bind_rows(table2,t2_cases_per_cap) %>%
  arrange(country,year,type,count)
#For table4a and table4b, create a new table for cases per capita, which we’ll name table4c, with country rows and year columns.

table4c <- tibble(
  country = table4a$country,
  `1999` = table4a[["1999"]] / table4b[["1999"]]*10000,
  `2000` = table4a[["2000"]] / table4b[["2000"]]*10000)
table4c

#common problems with datasets and how to solve them
#when some of the column names are not names of variables but values of a variable
#in table4a the columns names 1999 and 2000 represent values of the year variable,the values in these columns represent values of the cases variable and each row represents two obervations, not one.

table4a

#to tidy a dataset like this we need to pivot the offending columns into a new pair of variables
#to do so we need three parameters:
#1-the set of columns whose names are values
#2-the name of the variables to move the columns to
#3-the name of the variable to move the column values to
#use pivot-longer
tidy4a <- table4a %>% pivot_longer(c(`1999`, `2000`),
                         names_to = "year", 
                         values_to = "cases")

tidy4b <- table4b %>% pivot_longer(c(`1999`,`2000`),
                         names_to = "year",
                         values_to = "population")

#joining table4a and table4b with left_join
left_join(tidy4a,tidy4b)

#pivot_wider

#use it when an observation is scattered across multiple rows
#e.g. table2

table2

#2 parameters are needed
#1-the column to take the variable names from 
#2-the column to take values from

table2 %>%
  pivot_wider(names_from = type,
              values_from = count)

#exercises


