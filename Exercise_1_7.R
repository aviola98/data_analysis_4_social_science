#Exercise_1_7

#create two small tibble and join them by ID

ID <- c("A001","A002","A003")
Value <- c(10,20,50)
Population <- c(3000,2500,6000)

tibble_value <- tibble(ID=ID,
                       Value=Value)

tibble_population <- tibble(ID=ID,
                            Population=Population)


tibble_value_population <- tibble_value %>%
  left_join(tibble_population, by="ID")

View(tibble_value_population)

#Join flights and planes only by flights by carrier UA on september 16 2013 
#what is the most common plane model among these flights

View(flights)
flights_planes <- flights %>%
  filter(carrier == "UA" &
           day == 16 &
           month == 9) %>%
  left_join(planes, by="tailnum")

flights_planes %>%
  group_by(model) %>%
  tally() %>%
  top_n(1)

#the most common model is 757-222 and it appeared 31 times

#how many seats were installed (total) in the flights from JFK to ATL(Atlanta) in each month ?

flights %>%
  left_join(planes, by="tailnum") %>%
  filter(origin=="JFK",
         destination=="ATL") %>%
  group_by(month) %>%
  summarize(total_seats=sum(seats, na.rm=T))


#we want a summary of the flights in 2013 by airlines but flights doesn't have the official name of the companies
#join flights and airlines in order to create a clearer dataset

flights %>% 
  group_by(carrier) %>%
  tally() %>%
  left_join(airlines, by="carrier") %>%
  select(name,n)
  
