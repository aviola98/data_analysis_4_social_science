#Transformation

library(nycflights13)
library(tidyverse)

?flights
flights
View(flights)

#filter (it filters the dataset, the first argument,
#is the name of the data frame, the second and 
#subsequent arguments are the expressions that
#filter the data frame)

#example

filter(flights, month == 1, day == 1)

#saving the result
#wrap the assignment into parenthesis in order to
#both save the variable and print the result

(jan1 <-  filter(flights, month == 1, day == 1))

#comparisons
#all flights that departed in November or December

filter(flights, month == 11 | month == 12)

#using x%N%y selecting every row where x is one
#of the values in y

nov_dec <- filter(flights, month %n% c(11,12))

#using De Morgan's law to find flights that weren't
#delayed by more than two hours 

filter(flights, !(arr_delay > 120 | dep_delay >120))
filter(flights, arr_delay <= 120, dep_delay <=120)

#exercise

#Flights that had an arrival delay of two or more hours

arr_del_2more <- filter(flights, arr_delay >= 120)
View(arr_del_2more)

#flights that flew to Houston

houston_flights <- filter(flights, dest == "IAH" | dest == "HOU")
View(houston_flights)

#flights that were operated by United, American or Delta

aa_dl_ua <- filter(flights, carrier %in% c("AA","DL","UA"))
View(aa_dl_ua)

#flights that departed in summer (northern empisphere)

summer_flights <- filter(flights, month %in% c(7,8,9))
View(summer_flights)

#flights that arrived more than two hours late, but
#didn't leave late

arr_late_leave_not <- filter(flights, arr_time > 120 & dep_delay <= 0)
View(arr_late_leave_not)

#flights that were delayed by at least an hour,
#but made up over 30 minutes in flight

delay1_30min <- filter(flights, dep_delay >= 60,(dep_delay - arr_delay > 30))
View(delay1_30min)

#departed between midnight and 6am (inclusive)

dep0_dep6 <- filter(flights, between(dep_time, 601, 2359))
View(dep0_dep6)

#how many flights have a missing dep_time?
sum(is.na(flights$dep_time))
#what other variables are missing ?
map_dbl(flights, ~ sum(is.na(.x)))
