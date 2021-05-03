#advanced summaries

#calculate the total distance of the flights that took off from each airport as a new column

flights %>% group_by(origin) %>%
  summarize(dist_total=sum(distance,na.rm=T))

#calculate the mean of the average delay of each origin in each month

flights %>% group_by(origin,month) %>%
  summarize(mean_dep_delay=mean(departure_delay, na.rm=T)) %>%
  ungroup() %>% 
  summarize(mean_mean_dep_delay=mean(mean_dep_delay,na.rm=T))

#what is the percentage of flights in each destination ? what is the most common destination?

flights %>% 
  group_by(destination) %>%
  tally() %>%
  mutate(Pct_dest=100*(n/sum(n))) %>%
  arrange(-Pct_dest)

#what is the percentage of delay by carrier ? what is the carrier responsible for the biggest delay at Newark?
flights %>% group_by(origin,carrier) %>%
  summarize(total_delay=sum(departure_delay,na.rm = T)) %>%
  group_by(origin) %>%
  mutate(Pct_total_delay=100*(total_delay/sum(total_delay, na.rm=T))) %>%
  arrange(origin, -Pct_total_delay)
#creating a function in order to transform dep_delay arr_delay and air_time from minutes to hours

min_to_hours <- function(x) {
  return(x/60)
}

flights %>% mutate(across(c(departure_delay,arrival_delay,air_time), min_to_hours))

