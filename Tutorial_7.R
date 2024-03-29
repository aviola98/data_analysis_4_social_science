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

flights_JFK_ATL <- flights %>% filter(month==4 & 
                                        day==22 & 
                                        origin=="jfk" & 
                                        destination=="ATL")

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
flights_weather <- flights %>% left_join(weather, 
                                         c("origin", "year", "month", "day", "hour"))


#identifying the flights subject to a bigger wind speed

flights_weather %>%
  ungroup() %>%
  top_n(1, wind_speed)
#always include all the variables that are common identifiers in both databases

#Data set with missing data
#cleaner database without NAs 

#inner_join

flights %>% 
  inner_join(planes, by=c("tailnum"))

#often  inner_join has a selection bias since we don't know a lot about the missing planes but we can't ignore them for a quantitative analysis
#let's join the aiports and flights databases

#joining by destination since there are more aiports (by doing so we avoid repetition) 
#the destination identifier in airports is faa so we gotta change the name 

airports <- airports %>%
  #rename(dest=faa) this was the line I had put before but I corrected myself
  rename(destination=dest)

flights %>% left_join(airports, by=c("destination"))

#if we only want the complete name of the airport

flights %>%
  left_join(airports %>%
              select(destination,name),
            by=c("destination"))

flights %>% anti_join(airports, by=c("destination"))
airports %>% anti_join(flights, by=c("destination"))

#left join only conserves the data reffering to the left tibble
#but we can use the right join as well

flights %>%
  right_join(airports, by=c("destination"))

flights %>% right_join(airports, by=c("destination")) %>%
  filter(is.na(year)) %>%
  select(year, month, day, flight, destination, name)

#full_join preserves information form both databases

flights %>%
  full_join(airports, 
            by=c("destination"))



#five kinds of joins

#left_join (preserves all the observations from Database 1 with the additional columns from Database 2)
#right_join (preserves all the observations from Databse 2 with the additional columns from Database 1)
#inner_join (preserves only the observations that exists in both data)
#full_join (preservs all the observations from both data)
#anti_join (identifies the observations in Database 1 that do not exist in Database 2)

#Nesting Data


flights_nested <- flights %>%
  group_by(origin) %>%
  nest()

flights_nested %>%
  filter(origin == "ewr") %>%
  pull(data)


flights_nested <- flights %>% 
  group_by(origin, carrier) %>%
  nest() %>%
  arrange(carrier, origin)

flights_nested

flights_nested %>% unnest()

#the value of nesting is letting even clearer the structure and the content of our data
#we can explicitily work with the relevant data unity and hide the mountain of internal data


#combining nest with left_join
#letting clear that the unity of analysis is each plane
#avoiding the duplication of the planes data for each line
flights %>%
  group_by(tailnum) %>%
  nest() %>%
  left_join(planes, by=c("tailnum")) %>%
  rename("travels"="data")


