#Ex_1_12

#percentage of names of airlines that contain the word "Airlines" and what is the percentage of those containing the word "airways"

airlines %>%
  mutate(airlines=str_detect(name,"Airlines")) %>%
  group_by(airlines) %>%
  tally() %>%
  mutate(Pct=100*(n/sum(n)))
  
airlines %>%
  mutate(airways=str_detect(name,"Airways")) %>%
  group_by(airways) %>%
  tally() %>%
  mutate(Pct=100*(n/sum(n)))

#replacing the name of the airlines containing "Inc." with "Incorporated" and those containing "Co." with "Company"

airlines <-
airlines %>%
  mutate(name=str_replace(name, "Inc\\.","Incorporated"))

airlines <-
airlines %>%
  mutate(name=str_replace(name,"Co\\.", "Company"))

#generate a short name for each airline reflecting only their first name

airlines %>%
  mutate(short_name=str_split(name," "), short_name=map_chr(short_name,1))

#wordcloud for the airlines names

airlines %>%
  pull(name) %>%
  wordcloud()
