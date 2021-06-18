#Ex2_8

#open the shapefile of european countries and elaborate a simple
#map using the projection 23035
library("sf")
EU <- st_read("Europe.shp")

EU %>%
  st_transfrom(23035) %>%
  ggplot() +
  geom_sf()

#add the cities data from the exercise 1 to your map and give it an appropriate theme, title etc...

EU %>%
  st_transform(23035) %>%
  ggplot() +
  geom_sf()+
  geom_sf(data=tibble_capitals %>%
            st_transform(23035),
          color="blue",
          size=2) +
  ggtitle("Biggest cities in EU") +
  theme_minimal()

#the same map butn with the visualization of the national population
#also add the appropriate scale 
EU %>%
  st_transform(23035) %>%
  ggplot() +
  geom_sf(aes(fill=POP_EST))+
  geom_sf(data=tibble_capitals %>%
            st_transform(23035),
          color="blue",
          size=2) +
  ggtitle("Biggest cities in EU") +
  theme_minimal() +
  scale_fill_gradient(low = "#e5f5f9", high = "#00441b")

#Add Milano 
#we don't know the longitude and latitude of the city so we have to georeferenciate it 
#by adding "Piazza del Duomo, 20122 Milano, Italy" and add the results as another layer with the same layer formatting of the other cities
library(tmaptools)

Milano <- geocode_OSM("Piazza del Duomo, 20122 Milano, Italy",
                      projection=4326,
                      as.sf=T)
EU %>%
  st_transform(23035) %>%
  ggplot() +
  geom_sf(aes(fill=POP_EST))+
  geom_sf(data=tibble_capitals %>%
            st_transform(23035),
          color="blue",
          size=2) +
  geom_sf(data=Milano %>%
            st_transform(23035),
          color="blue",
          size=2)+
  ggtitle("Biggest cities in EU") +
  theme_minimal() +
  scale_fill_gradient(low = "#e5f5f9", high = "#00441b")

#Non spatial joins



