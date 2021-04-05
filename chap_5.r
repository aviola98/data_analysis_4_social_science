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

#arrange

arrange(flights, year, month, day)

arrange(flights, desc(dep_delay))

df <- tibble(x = c(5, 2, NA))
arrange(df,x)

#How could you use arrange to sort all missing 
#values to the start ?

df <- tibble(x = c(5,2,NA),
             y = c(2, NA, 2))
#sorting the values that are TRUE for NA to the start
rowSums(df)
arrange(df, desc(is.na(x)))
arrange(df, -(is.na(x)))

#sort flights to find the most delayed flights
#find the flights that left earliest

arrange(flights, dep_delay)
arrange(flights, desc(dep_delay))

#sort flights to find the fastest(highest speed) flights

arrange(flights, air_time)

#Which flights traveled the longest ? Which traveled the shortest ?
#longest
flights %>% 
  arrange(air_time)%>%
  select(carrier, flight, air_time)
#shortest
flights %>%
  arrange(-air_time) %>%
  select(carrier, flight, air_time)

#select
#select columns by name
select(flights, year, month, day)
#select all columns between year and day
select(flights, year:day)
#select all columns except those from year to day
select(flights, -(year:day))

#starts_with()
#ends_with()
#contains()
#mathces()
#num_range()

#rename in order to rename variables

rename(flights, tail_num = tailnum)

#select + everything in order to move variables
#to the start of the data frame

select(flights, time_hour, air_time, everything())

#exercises
#Brainstorm as many ways as possible to select 
#dep_time, dep_delay, arr_time, and arr_delay
#from flights.

#first way
select(flights, dep_time, dep_delay, arr_time, arr_delay)

#second way
select(flights, starts_with(c("dep", "arr")))

#third way

select(flights, ends_with(c("delay","time")))

#What does the any_of() function do? Why might it be helpful in conjunction with this vector?

vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, any_of(vars))

#Does the result of running the following code surprise you? How do the select helpers deal with case by default? How can you change that default?

select(flights, contains("TIME"))

#mutate 
#it creates new columns that are functions of
#existing columns

flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time
                      )
View(flights_sml)
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60
       )

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)

#if you only want to keep the new variables 
#use transmute()

transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

#computing hour and minute from dep_time
#using modular arithmetic 

transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100)

#Currently dep_time and sched_dep_time are
#convenient to look at, but hard to compute with 
#because they’re not really continuous numbers.
#Convert them to a more convenient representation
#of number of minutes since midnight.

flights <- mutate(flights,
                  dep_time_mins = dep_time %/% 100 * 60 + dep_time %% 100,
                  sched_dep_time_mins = sched_dep_time %/% 100 * 60 +
                    sched_dep_time %% 100)

select(flights, starts_with('dep_time'), starts_with('sched'))
#Compare air_time with arr_time - dep_time.
#What do you expect to see? What do you see? 
#What do you need to do to fix it?


#air_time is the amount of time spent in  air in
#minutes, and we should expect air_time to be
#the same as arr_time - dep_time

flights %>% 
  mutate(flight_time = arr_time - dep_time) %>%
  select(air_time, flight_time)

#the difference between them is because
#arr_time and dep_time are not continuos numbers
#to remedy this we convert arr_time to minutes
#since midnight same as previous question 

flights <- mutate(flights, 
                  arr_time_min = arr_time %/% 100 * 60 +
                    arr_time %% 100)
flights <- mutate(flights, flight_time = arr_time_min - dep_time_mins)

select(flights, air_time, flight_time)

#again air_time is different from the computed
#flight_time, in fact, only 196 flights have the same 
#air_time and computed flight_time

sum(flights$air_time == flights$flight_time, na.rm = TRUE)

#Compare dep_time, sched_dep_time, and dep_delay.
#How would you expect those three numbers to be
#related?

select(flights, dep_time, sched_dep_time, dep_delay)

#Find the 10 most delayed flights using a ranking
#function. How do you want to handle ties?
#Carefully read the documentation for min_rank().
#min_rank() is equivalent to rank() method with 
#the argument ties.method = 'min. It assigns 
#every tied element to the lowest rank.

head(arrange(flights, min_rank(desc(dep_delay))), 10)

#5 – What does 1:3 + 1:10 return? Why?

1:3 + 1:10

#R performs vectorized calculations.
#For example, when we add two vectors of the same
#length together, c(1,2,3) + c(4,5,6), the result
#will be c(5,7,9). When we add two vectors of
#different lengths, the shorter vector with be 
#‘repeated’ to match the length of the longer 
#vector.

#summarise
#na.rm argument removes the missing values prior to computation
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
#getting the average delay by date
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

#pipe 
#code without pipe
#group flights by destination
by_dest <- group_by(flights, dest)
#summarise to compute distance,average delay and number of flights
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                               delay = mean(arr_delay, na.rm = TRUE)
                               )
#filter to remove noisy points and Honolulu airport, which is almost twice as far away as the next closest airport

delay <- filter(delay, count > 20, dest != "HNL")

#plot
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)
#it shows that delays increase with distance up to
#750 miles and then decrease

#code with the pipe
#read %>% as "then"

delays <- flights %>% 
  group_by(dest) %>%
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  filter(count > 20, dest != "HNL")

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)


#applications of na.rm

flights %>%
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay, na.rm = TRUE))

#First remove the missing flights
#create a variable so that you can re-use it in the next examples

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay))

#counts
#taking a look at the planes that have the highest
#average delays
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x=delay)) +
  geom_freqpoly(binwidth = 10)

#scatterplot of number of flights vs. average delay

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

#unsurprisingly there is much greater variation in the average delay
#when there are few flights
#whenever you plot a mean (or other summary) vs. group size, you'll see
#that the variation decreases as the sample size increases 

#removing the smallest number of observartion

delays %>%
  filter(n > 25) %>%
  ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

