#statistical test

library("tidyverse")
library("tidylog")
library("nycflights13")
#using broom in order to use tidy and clean the table
library("broom")
library("stargazer")

# t-est para avaliar medias de uma variavel continua
#t test in order to compare means of a continuous variables

?tidy

#datavase
#manipulate the data
#run the test
#clean and organize the results


flights %>% filter(origin!="jfk") %>%
  t.test(departure_time~origin,
         data=.) %>%
  tidy() 

#correlation test
#2 continuos variables

flights %>%
  cor.test(~departure_time+arrival_time,
          data=.) %>%
  tidy()


flights %>%
  cor.test(~departure_time+arrival_time,data=.,
           method="spearman")%>%
  tidy()

#shapiro test (when the asks for a vector instead of a table)
flights %>% sample_n(5000) %>% 
  pull(departure_time) %>%
  shapiro.test() %>%
  tidy()
#the data here isn't normal

#Regression is a very simple thing , it is basically a sofisticated correlation
#do not be intimidated with regressions, they are nothing more than regressions

#linear model (flexible correlation)

flights %>%
  lm(arrival_delay~origin,
     data=.) %>%
  tidy()

#with explanatory variables
flights %>%
  lm(arrival_delay~origin + month + carrier,
     data=.) %>%
  tidy()

#table with stargazer 
flights %>%
  lm(arrival_delay~origin + month + carrier,
     data=.) %>%
  stargazer(type = "html")

#{r, results='asis'}


