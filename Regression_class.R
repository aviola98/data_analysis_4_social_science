library(tidyverse)
library(dplyr)
library(nycflights13)
#we have data with at least one variable and we want to evaluate wheter a fact (null hypotesis) about our data is real
#so we compare our real data with a reference distribution assuming that this null hypotesis is real
#we evaluate the strength of our data (i.e. the available evidence) taking into account the amount of observations that we have in order to extract the information
#we summarize the strength of the information with a p-value that estimates how feaseble would be to observe our data if the null hypotesis is real 
#a low p-value means that it would be strange to observe our data if the fact is real so the null hypotesis is probably not real

#Normalizing tests

#a test in order to see if our data is normally distributed
#Shapiro-Wilk test(it compares the data with a perfect normal distribution and evaluates how fat they are from it)

#encoraging R not to use scientific numbers
options(scipen=999)
  

flights %>%
  sample_n(3000) %>%
  pull(departure_delay) %>%
  shapiro.test()

#in this case the p-value is small so our distribution is probably not normal

flights %>%
  ggplot() +
  geom_density(aes(x=departure_delay)) +
  xlim(0,100)


#library broom to transform statistical tests in a tibble
library(broom)

normality_test <- flights %>%
  sample_n(3000) %>%
  pull(departure_delay) %>%
  shapiro.test() %>%
  tidy()

normality_test


#`r normality_test %>% pull(p.value) %>% round(3)` 
#we use round(3) at the end of the flow in order to round numeric values



#T-tests
#comparison between means
#e.g. the average delay in 2012 was 13.4 hours 
#let's compare it with the data of 2013
mean_test <- flights %>%
  filter(origin!="LGA") %>%
  pull(departure_delay) %>%
  t.test(mu=13.4) %>%
  tidy()

mean_test

#it seems that the average delay in 2013 was bigger than in 2012

mean_test %>%
  mutate(Variable="Departure delay") %>%
  ggplot() +
  geom_point(aes(x=Variable, y=estimate)) +
  geom_hline(yintercept=13.4,
             lty=2,
             color="blue") +
  geom_errorbar(aes(x=Variable, 
                    ymin=conf.low,
                    ymax=conf.high),
                width=0.1)

#comparing means

#let's see if the average delay in EWR is different from JFK

#Formula
#a syntaxis to compare a dependent variable (the results we want to compare) 
#with independent variables(that divide our data in groups )
#dependent ~ independet
#dependent ~indepent1 + independent2 


flights %>% filter(origin!="LGA") %>% 
  t.test(departure_delay ~ origin, data=.) %>% 
  tidy()


#correlation tests

flights %>%
  cor.test(~departure_delay + departure_time, data=.) %>%
  tidy()
#Pearson coefficient is 0.26 which is positive and a p-value of 0 which indicates a positive and statistically relevant correlation between the departure time and delay

#graph
flights %>% sample_n(1000) %>% 
  ggplot() +
  geom_point(aes(x=departure_time, 
                 y=departure_delay)) +
  geom_smooth(aes(x=departure_time, 
                  y=departure_delay), 
              method="lm")



#can we compare two categorical variables ?
#origin and carrier in order to know if the same companies fly from each airport with the same frequency
#CHI-SQUARED TEST

flights %>%
  select(origin,carrier) %>%
  table() %>%
  chisq.test() %>%
  tidy()

#SImple Regression

#regression is a correlation 

#linear regression

flights %>%
  lm(departure_delay~departure_time, data=.) %>%
  #asking for more details
  summary()

#using tidy

flights %>%
  lm(departure_delay~departure_time, data=.) %>%
  tidy()

#adding another variable

flights %>%
  lm(departure_delay~departure_time+origin, data=.) %>%
  tidy()

#in order to specify a relationship between an independent variable 
#and a non linear dependent variable (e.g. quadratic) we have to use the function I()

flights %>%
  lm(departure_delay~departure_time+I(departure_time^2), data=.) %>%
  tidy()

#using stargazer in order to use a professional table for regressions
library(stargazer)

flights %>%
  lm(departure_delay~departure_time+origin, data=.) %>%
  stargazer(type="html")

#specifying a title, renaming the variables, adjusting the location of the standard deviations and choosing the needed statistics

flights %>%
  lm(departure_delay~departure_time+origin, data=.) %>%
  stargazer(type="html",
            title="Model of Flights Delay",
            single.row=T,
            keep.stat=c("n"),
            dep.var.labels = "Delay",
            covariate.labels = c("Time","JFK","LGA"),
            header=F,
            dep.var.caption = "")

#in case you want to compare two similar models on the same table you can save two regressions as objects and forward them to a list in stargazer

reg1 <- flights %>% lm(departure_delay ~ departure_time, data=.)
reg2 <- flights %>% lm(departure_delay ~ departure_time + origin, data=.)

list(reg1,reg2) %>%
  stargazer(type="html")

#visualization

#let's analyze the estimative of the marginal effects of two explanatory variables 
#using the combination tidy() and ggplot()

reg2 %>% tidy() %>%
  #adjusting the estimative to 1.96 which corresponds to 95% of confidence in the t distribution
  #multiplying it by the std error
  mutate(conf.lo=estimate-1.96*std.error,
         conf.hi=estimate+1.96*std.error) %>%
  #removing the intercept
  filter(term!="(Intercept)") %>%
  ggplot() +
  geom_point(aes(x=term, y=estimate)) +
  geom_errorbar(aes(x=term, y=estimate, ymin=conf.lo, ymax=conf.hi), width=0.1) +
  geom_hline(yintercept=0, lty=2)



#binary variables need a logit model
library(Zelig)









