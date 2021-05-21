#Tutorial 7

#joining databases

#most projects require a combination of differente databases (e.g. in order to study the
#effect of a government program on voting we need at least 2 databases: one with the
#data regarding the programm localization and other with the electoral results)

#first we need to understand the databases:
#I- what is the unit of analysis of each observation ?
#II-which are the unique identifiers in each database that uniquely identify each
#observation (avoiding duplication) ?
#III- Which are the common identifiers present in both databases that allow us to
#cross information ?

#Different units

#We have to decide the desired unity of analysis for the final database

#e.g.
#by state (adding the databae with more units)
#%>% group_by(state) %>% summarize()
#by municipality(duplicating the database with less units)
#but R needs to know in which states the municipalities are in so we have to find
#a way to add a new column that indicates the state in the electoral dabatase in order
#to make the crossing easy

#simple joins examples
#left_join
#we have to define three arguments (the names of the two databases and the name
#of the common identifier(key) that we'll use to join the databases)

#Database_1 %>% left_join(Database_2, "Common Identifier")

#e.g. with flights
library("tidyverse")
library("tidylog")
library("nycflights13")

flights_JFK_ATL <- flights %>%
  filter(month == 4 &
           day == 22 &
           origin == "JFK" &
           destination == "ATL") 

View(flights_JFK_ATL)

#notice that tailnum only appear 5 times on the table above.
#Now it is easy to cross the tables with a common identifier

flights_JFK_ATL %>% left_join(planes, by="tailnum")

#we basically added the data by plane at the end of the database

#aggregating data with more units 

#creating a dataset with the number of flights by plane
flights_by_plane <- flights %>%
  group_by(tailnum) %>%
  tally()

View(flights_by_plane)
#now we can join it to the planes dataset using the common identifier tailnum
planes_with_travel_number <- planes %>%
  left_join(flights_by_plane, by="tailnum")

View(planes_with_travel_number)

#Doubling the dataset with less units 
#generating a new tibble with each flight option and adding airplane data to the flights database

flights_with_planes <- flights %>%
  left_join(planes, by="tailnum")

View(flights_with_planes)

#let's filter the database in order to see that the airplane data repeats itself each time a plane travels

flights_with_planes %>%
  filter(destination=="GSO") %>%
  arrange(tailnum) %>%
  select(tailnum, month, day, departure_time, manufacturer, year.x, year.y, model)

#it's always good to rename the variables before we join a database to another to avoid conflicts and to better describe our variables
planes <- planes %>%
  rename("fabrication_year"="year")

flights_with_planes <- flights_with_planes %>%
  left_join(planes, by="tailnum")

#now we can use this tibble in order to analyze and visualize data
#e.g.  let's summarise the number of flights by fabrication year

flights_with_planes %>%
  group_by(fabrication_year) %>%
  tally() %>%
  ggplot() +
  geom_col(aes(x=fabrication_year,
               y=n))
#identifing missing observations

#anti_join(we use it in order to identify the observations that exist in a databse but not in another)

flights %>% 
  anti_join(planes,by="tailnum")
#there are 52606 tailnums in flights that do not exist in planes

planes %>%
  anti_join(flights, by="tailnum")
#all the planes present in planes are available in flights

#Joining the dataset by multiple variables

flights_weather <- flights%>%
  left_join(weather,
            c("origin","year","month","day","hour"))

View(flights_weather)

#identifying the flights subject to a bigger wind speed

flights_weather %>%
  ungroup() %>%
  top_n(1,wind_speed)
#always include all the variables that are common identifiers in both databases