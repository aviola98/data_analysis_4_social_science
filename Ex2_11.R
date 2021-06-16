#generate a nested tibble with a row for each month using the database weather
nested_weather <- weather %>%
  group_by(month) %>%
  nest()

#add a column to the aforegenerated tibble showing the number of observations for each month 

nested_weather <- nested_weather %>%
  mutate(obs=map_dbl(data,nrow))

#execute a regression for each month separatedly
#with precip as dependent variable and temp as independent variable
#save the coefficient of the temperature variable in a new column

nested_weather_reg <- nested_weather %>%
  mutate(regression=map(data, ~lm(precip~temp, data=.)),
         regression=map(regression, tidy),
         coef=map(regression, filter, term=="temp"),
         coef=map_dbl(coef,pull,estimate))

#separate the temperature column of each month in a new nested column as a vector for each month 
#and apply the shapiro test for the temperature in each month 
#process the result so that the p-value is visible in the summary tibble per month 
