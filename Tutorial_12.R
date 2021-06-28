#Tutorial 12
#Text analysis

library("nycflights13")
library("tidyverse")
library("tidylog")

#pulling the string of the first airport in airports
airports %>% 
  slice(1) %>% 
  pull(name)

#stringr

#measuring the number of characters with str_length

airports <-
airports %>%
  mutate(charactrers=str_length(name))

#identifying the presence of a string with str_detect
#identifying airports with the word "field"

airports <-
airports %>%
  mutate(str_field=str_detect(name,"Field"))

#using the new variable str_filed to identify how many fields there are in the US
airports %>%
  group_by(str_field) %>%
  tally()

#regex
#using a regular expression in order to capture a variety of possibilites

#e.g.: capturing the airports containing "Regional" or "Rgnl" 

airports %>%
  mutate(str_regional=str_detect(name,"Regional|Rgl")) %>%
  filter(str_regional==T) %>%
  select(name)

#identifying the names that start with Z
#we use ^to detect characters at the beginning of a string and 
#$ to indentify those at the end

airports %>%
  mutate(str_z=str_detect(name,"^Z")) %>%
  filter(str_z==T) %>%
  select(name)

#identifying names that contain at least 2 f's or g's together

airports %>%
  mutate(str_ffgg=str_detect(name,"[fg]{2,}"))%>%
  filter(str_ffgg==T)%>%
  select(name)

#transforming strings

