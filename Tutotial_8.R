#Maps and Spacial Analysis

#spacial data contain variables that identify the location of each point in the world
#such as latitude and longitude
#these values allow us to localize any point in the world, compare it with other points and visualize the points in a map and its dimensions

library("tidyverse")
library("ggplot2")
library("tidylog")
library("nycflights13")
library("sf")
library("dplyr")
library("lwgeom")

#sf gives more power to our tibbles allowing them to understand spacial data
#we have to indicate to R which variables are the longitude and latitude in the original tibble
#using st_as_sf() , coords=c(longitude, latitude)

airports_test <- airports %>%
  st_as_sf(coords=c("lon","lat"))

View(airports_test)

class(airports_test)

airports_test %>%
  ggplot() +
  geom_sf()

#let's limite our data to the timezone of continental US and also removing some bad codified airports

airports_test <- airports_test %>%
  filter(tz<0 & 
           !(faa %in% c("EEN","SYA")))

airports_test %>%
  ggplot()+
  geom_sf()

#coordenate system CRS

#we have to know 3 things
#1- get to know the CRS of our brute data

airports <- airports %>%
  st_as_sf(coords=c("lon","lat"),
           crs=4326) %>%
  filter(tz<0 & 
           !(faa %in% c("EEN","SYA")))

#we use 4326 in order to specify the system WGS84 (a system of non coordiante geographic coordiantes)

#2-choose the CRS that we want to visualize our data
#we can transform the CRS into an alternative one 
#in order to do so we use st_transform()
#e.g. Mercator 3857

airports %>%
  st_transform(3857) %>%
  ggplot() +
  geom_sf()

#a projection focused on the US 3751

airports %>%
  st_transform(3751) %>%
  ggplot() +
  geom_sf()

#3-all the layers in our analysis/visualization must use the same projection

#calculing distances

#CRS is especially useful when we want to calculate distances of spacial observations
#CRS 4326 is geographic (without projection, in three dimensions), so the distance unit is still the world's curvature
#in contrast, when we use st_transform() and we point out a different CRS from the projected one the localizations are set in a bi-dimensional plane and the measures of ditance are straight lines (Euclidean Distance)

#st_distance()

airports %>%
  sample_n(10) %>%
  st_distance() %>%
  #transformig the matrix in a tibble 
  as_tibble()

#a different projection gives you a different result

airports %>%
  st_transform(3751) %>%
  sample_n(10) %>%
  st_distance() %>%
  as_tibble()
  
