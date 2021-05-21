#Exercise 3_6


#prepare a point graph showing the relationship between departure delay and arrival
#delay to flights from JFK and MIA
#color the points according to the carrier and add well formated titles on the axis
#and to the whole graph

flights %>%
  filter(origin=="JFK",
         destination=="MIA") %>%
  ggplot() +
  geom_point(aes(x=departure_delay,
                 y=arrival_delay,
                 color=carrier)) +
  scale_color_brewer(palette="Set2") +
  ggtitle("Relationship between departure delay and arrival delay for flights from JFK to MIA")+
  xlab("Departure Delay")+
  ylab("Arrival Delay") 

#instead of carrier, now the dots have to be colored according to a continuous variable
#in this case departure time

flights %>%
  filter(origin=="JFK",
         destination=="MIA") %>%
  ggplot() +
  geom_point(aes(x=departure_delay,
                 y=arrival_delay,
                 color=departure_time)) +
  scale_color_gradient(low="#ffeda0",
                       high="#f03b20") +
  ggtitle("Relationship between departure delay and arrival delay for flights from JFK to MIA")+
  xlab("Departure Delay")+
  ylab("Arrival Delay") 

#prepare a line graph showing the travel distance of all flights per month 
#each line represents an origin

flights %>%
  mutate(month=factor(month, 1:12, ordered=T)) %>%
  group_by(month,origin) %>%
  summarize(total_distance=sum(distance,na.rm=T)) %>%
  ggplot() +
  geom_line(aes(x=month,
                y=total_distance,
                group=origin,
                color=origin)) +
  scale_color_brewer(palette="Set2")

#prepare several graphs in a line, each of them showing the relationship between
#departure hour and average delay in each origin by carrier

flights %>% group_by(hour, origin, carrier) %>%
  summarize(dep_delay_media=mean(dep_delay,na.rm=T)) %>%
  ggplot() + 
  geom_line(aes(x=hour, y=dep_delay_media)) +
  facet_grid(rows=vars(carrier), cols=vars(origin))

