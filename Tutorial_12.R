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

#replacing Rgnl with regional using str_replace

airports <- airports %>%
  mutate(name=str_replace(name,"Rgnl","Regional"))

#replacing hifens with a space

airports <- airports %>%
  mutate(name=str_replace(name,"-"," "))

#using str_spĺit to split each word by space

airports <- airports %>%
  mutate(partial_name=str_split(name, " "))

#selecting the first and last string using map_chr
airports <- airports %>%
  mutate(first_partial_name=map_chr(partial_name,1))
airports <- airports %>%
  mutate(last_partial_name=map_chr(partial_name,tail,n=1))

#using separate() is useful when we have a fixed format with a foreseeable pattern

#separating tzone using /

airports <- airports %>%
  separate(tzone,"/", into=c("Country","Region"))

View(airports)

#Escape characters

#if we want to pool a quote out of the text , instead of using "" we use "\"
#but if we want to split a text using \ we have to use "\\\\"

#String visualization

library(wordcloud)
library(tm)

airports %>%
  pull(name) %>%
  wordcloud()

#ggwordcloud package
