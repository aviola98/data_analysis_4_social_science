#Text Analysis
library("nycflights13")
library("tidyverse")
library("tidylog")
#working with the airlines data

#the functions to analyzie text data start with str_
#it comes from "string"

#str_length
#measuring the size of a text
airlines %>%
  mutate(name_size=str_length(name))

#str_detect
#detecting string that contain a character or a set of characters
airlines %>%
  mutate(name_h=str_detect(name, "h"))
#whole word
airlines %>%
  mutate(name_airlines=str_detect(name, "Airlines"))

#amplifying the conditions

#str_split
airlines %>%
  mutate(name_split=str_split(name," "),
         name_split=map_chr(name_split,1))

#str_replace
airlines %>%
 mutate(name2=str_replace(name,"Inc.",
                          ""))

library(tidytext)
#unnest_tokens
?unnest_tokens
airlines_words <- airlines %>%
  unnest_tokens(text,name)

library(lexicon)
library(lexiconPT)
library(textstem)

stopwords <- get_stopwords(language="en") %>%
  rename("text"="word") %>%
  add_row(text="inc",lexicon="snowball")

airlines_words <- airlines_words %>%
  anti_join(stopwords,by="text")

