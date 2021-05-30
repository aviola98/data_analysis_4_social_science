#Exercise1_8
library(tidyverse)

City <- c("Paris","London","Istanbul","Madrid","Berlin")
Country <- c("France","UK","Turkey","Spain","Germany")
Population <- c(12006868,11984435, 11400000,6633278, 5142247)
Long <- c(2.352552,-0.128285,28.976636,-3.708597, 13.402067)
Lat <- c(48.85771,51.50724,41.00799,40.41167,52.52013)


tibble_capitals <- tibble(City=City,
                          Country=Country,
                          Population=Population,
                          Long=Long,
                          Lat=Lat)

#create a simple features object with the data above
#long and lat are computed in CRS=4326

tibble_capitals <- tibble_capitals %>%
  st_as_sf(coords=c("Long","Lat"),
           crs=4326,
           remove=F)

tibble_capitals

#elaborate a simple map in order to visualize these data (with a different color for each point 
#based on the population variable) 

tibble_capitals %>%
  ggplot() +
  geom_sf(aes(color=Population)) +
  theme_minimal()

#we can use remove=F in order to preserve the columns of longitude and latitude explicitely
#use these two columns in order to add geom_text() which prints the names of the citites above

tibble_capitals %>%
  ggplot() +
  geom_sf(aes(color=Population)) +
  geom_text(aes(x=Long, y= (Lat - 0.5), label=City))+
  theme_minimal()

#remove the names of the cities and transform your data into the projection CRS 23035 and present a new map

tibble_capitals %>%
  st_transform(23035) %>%
  ggplot() +
  geom_sf(aes(color=Population)) +
  theme_minimal()

#calculate the matrix of the euclidian distance between cities

tibble_capitals %>%
  st_transform(23035) %>%
  st_distance()%>%
  as_tibble()

