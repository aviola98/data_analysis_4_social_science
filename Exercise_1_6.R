#Exercise_1_6

#prepare a barr graph showing the number of flights per month

library(nycflights13)

flights %>%
  ggplot() +
  geom_bar(aes(x=month),color = "black",
           fill="orange")



#prepare a bar graph showing the number of flights by carrier to the JFK airport

flights %>%
  filter(origin=="JFK") %>%
  ggplot() +
  geom_bar(aes(x=carrier, fill=carrier), color="black")


#prepare a histogram showing the distribution of number of flights by departure time
#for flights between EWR and SFO(San Francisco)

flights %>%
  filter(origin=="EWR",
         destination=="SFO") %>%
  ggplot() +
  geom_histogram(aes(x=departure_time),
                 color="black",
                 fill="yellow")

#prepare a density graph showing the distribution of the duration of flights
#between JFK and LAX(Los Angeles)

flights %>%
  filter(origin == "JFK",
         destination == "LAX") %>%
  ggplot() +
  geom_density(aes(air_time),
               color="black",
               fill="red",
               alpha=0.2)