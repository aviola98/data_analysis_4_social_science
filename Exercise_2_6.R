#prepare a density graph showing the distribution of the departure time of the flights 
#between EWR and BOS(Boston) by carrier

View(flights)
#color fill alphja
flights %>% 
  group_by(carrier) %>%
  filter(origin == "EWR",
         destination == "BOS") %>%
  ggplot() +
  geom_density(aes(x=dep_time,
                   color = carrier,
                   fill = carrier,
                   alpha=0.2))

#prepare a barr graph showing the average air time of each carrier

flights %>%
  group_by(carrier) %>%
  summarize(mean_duration = mean(air_time, na.rm=T))%>%
  ggplot() +
  geom_col(aes(x = carrier,
               y = mean_duration,
               fill = carrier),
           color = "black")

#prepare a point graph showing the relationship between the departure delay
#and the arrival delay to fligths from JFK to MIA (Miami)

flights %>%
  filter(origin == "JFK",
         destination == "MIA") %>%
  ggplot () +
  geom_point(aes(x = departure_delay,
                 y = arrival_delay))

#prepare a point graph showing the relationship between the average air time and the average delay of each carrier

flights %>%
  group_by(carrier) %>%
  summarize(mean_air_time = mean(air_time, na.rm = T),
            mean_dep_delay = mean(departure_delay, na.rm = T)) %>%
  ggplot()  +
  geom_point(aes(x = mean_air_time,
                 y = mean_dep_delay))

#adding a linear regression line on the previous'question graph

flights %>% 
  group_by(carrier) %>%
  summarize(mean_air_time = mean(air_time, na.rm = T),
            mean_dep_delay = mean(departure_delay, na.rm =T)) %>%
  ggplot() +
  geom_point(aes(x = mean_air_time,
                 y = mean_dep_delay)) +
  geom_smooth(aes(x= mean_air_time,
                  y = mean_dep_delay),
              method = "lm",
              se = F)





