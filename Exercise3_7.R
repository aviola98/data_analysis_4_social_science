#Ex_3_7

#creating a nested tibble in which the unity of analysis is each combination of origin and destination 
#and in the other column there are the all the details of flights between that origin and that destination

flights %>%
  group_by(origin, destination) %>%
  nest()

#creating a  nested tibble that summarizes the database flights by airport  by origin month day and hour 
#use join in order to join the data from weather for ach airport and hour

flights %>%
  group_by(origin, month ,day, hour) %>%
  nest() %>%
  left_join(weather, by = c("origin","month","day","hour"))

