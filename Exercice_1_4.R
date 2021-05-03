#calculating the mean distance by carrier

flights %>%
  group_by(carrier) %>%
  summarize(mean_airtime=mean(air_time, na.rm=T))

#calculating the mean air time by carrier and month

flights %>%
  group_by(carrier,month) %>%
  summarize(mean_airtime=mean(air_time, na.rm=T))

#calculating the average delay by origin

flights %>%
  group_by(origin) %>%
  summarize(average_delay=mean(departure_delay, na.rm=T))

#the airport with the worst delay was EWR

#which air company has the average worst delay record in JFK ?

flights %>%
  filter(origin == "jfk") %>%
  group_by(carrier) %>%
  summarize(mean_delay=mean(departure_delay, na.rm=T)) %>%
  arrange(-mean_delay)

#what is the worst month to travel from JFK ?

flights %>%
  filter(origin == "jfk") %>%
  group_by(month) %>%
  summarize(mean_dep_delay=mean(departure_delay, na.rm=T)) %>%
  arrange(-mean_dep_delay)
#june


