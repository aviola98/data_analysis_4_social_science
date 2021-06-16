#generate three separate tibbles derived from the flights database 
#for each airport of origin. Then, put the three tibbles into a unique list  with the name of each element of the list and the airport sigla

library(tidyverse)
library(nycflights13)

flights_ewr <- flights %>% 
  filter(origin == "ewr")

flights_lga <- flights %>%
  filter(origin=="lga")

flights_jfk <- flights %>%
  filter(origin=="jfk")

origin_list <- list(EWR=flights_ewr,
                    LGA=flights_lga,
                    JFK=flights_jfk) 

origin_list

#use map in order to calculate the number of observations(flights) in each tibble using the nrow function

origin_list %>%
  map(nrow)

#filter the three databases for flights with destiny SFO(San Francisco) using map 
#how many observations has each airport of New York to San Francisco ?

origin_list %>%
  map(filter, destination == "SFO") %>%
  map(nrow)

#EWR has 5127, LGA has 0 and JFK has 8204 flights to San Francisco

#calculate the speed of each flight using map

origin_list %>%
  map(mutate, speed=distance/air_time, na.rm=T)

#summarize each of your database in order to calculate the average speed of the flights using a function from the map family
#the result must be a tibble with all the appropriate details
origin_list %>%
  map(mutate,speed=distance/air_time, na.rm=T) %>%
  map_df(summarize,
         mean_speed=mean(speed, na.rm=T),
         .id="origin")
  
