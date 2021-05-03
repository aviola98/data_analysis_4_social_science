#how many flights took off from NY in each month of 2013 ?

flights %>%
  group_by(month) %>%
  tally()

#which company had the largest number of flights for each month of 2013 ?

flights %>%
  group_by(carrier, month) %>%
  tally() %>%
  group_by(month) %>%
  top_n(1,n)

#what is the average of the number of flights who took off from the three airports in each month ?

flights %>%
  group_by(origin,month) %>%
  tally() %>%
  group_by(month) %>%
  summarize(mean_n=mean(n, na.rm=T))

#what is the monthly average of the number of flights taht took off from each airport ?

flights %>%
  group_by(origin,month) %>%
  tally() %>%
  group_by(origin) %>%
  summarize(mean_n=mean(n,na.rm=T))

#what is the second most congested departure time in each airport ?

flights %>%
  group_by(origin,departure_time) %>%
  tally() %>%
  group_by(origin) %>%
  top_n(2,n)
  


