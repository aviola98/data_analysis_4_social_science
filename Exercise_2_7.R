#create two tibbles and join them using left_join

ID <- c("A001","A001","A002","A003","A003")
Year <- c(2019,2020,2020,2019,2020)
Population <- c(3000,2500,1900,6000)
Value <- c(10,12,17,50,64)

tibble_value_2 <- tibble(ID=ID,
                         Year=Year,
                         Value=Value)


ID_2 <- c("A001","A0012","A002","A003")
Year_2 <- c(2019,2019,2020,2019)

tibble_population_2 <- tibble(ID=ID_2,
                              Year=Year_2,
                              Population=Population)
#clean database that only preserves the observations with complete data for both value and population

tibble_value_population <- tibble_value_2 %>% 
  inner_join(tibble_population_2, c("ID","Year"))

tibble_value_population  

#complete database that contains all observations even if they do not exist in the other database

tibble_value_population_complete <- 
  tibble_value_2 %>%
  full_join(tibble_population_2, c("ID","Year"))

tibble_value_population_complete


#using the databases flights and weather identify the average precipitation at the moment of departure for flights from LGA in each day of december
flights %>% left_join(weather, by=c("origin", "year", "month", "day", "hour")) %>%
  filter(month==12 &
           origin=="lga")

#for how many flights in each day of december from LGA we have missing data time

flights %>% left_join(weather, by=c("origin", "year", "month", "day", "hour")) %>%
  filter(month==12 & origin=="lga") %>%
  group_by(day) %>%
  summarize(precip_media=mean(precip, na.rm=T))

#for how many hours in each day of december in LGA we have data about time but we dont have any flight

weather %>%
  filter(month == 12 & origin == "lga") %>%
  anti_join(flights, by = c("origin", "year", "month", "day", "hour")) %>%
  group_by(day) %>%
  tally()



#lets investigate if visibility affects the number of departures per hours

num_flights_per_hour <- flights %>%
  group_by(year, month, day, hour, origin) %>%
  tally()

weather_num_flights_per_hour <- weather %>%
  left_join(num_voos_per_hora, by = c("origin", "year", "month", "day", 
                                      "hour"))
weather_num_flights_per_hour


#summarize your database above in order to estimate the average flight number b per hour of visibility

weather_num_flights_per_hour %>%
  group_by(visib) %>%
  summarize(mean_n = mean(n, na.rm=T)) %>%
  ggplot() +
  geom_point(aes(x=visib,
                 y=mean_n))