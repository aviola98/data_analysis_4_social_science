#Functions and Repetitions

library("nycflights13")
library("tidyverse")

#generating a function in order to calculate the amplitude

amplitude <- function(x) {
  #subtracting the maximum and the minimum of a variable
  resultado <- max(x,na.rm=T) - min(x,na.rm=T)
  return(resultado)
}
#e.g.
flights %>%
  pull(departure_delay) %>%
  amplitude()

#rounding the results in the previous function

amplitude <- function(x) {
  resultado <- max(x,na.rm=T) - min(x, na.rm=T)
  return(round(resultado, 0))
}

flights %>% 
  pull(departure_delay) %>%
  amplitude

#using map in order to apply the function to a series of objects

flights %>%
  select(departure_delay, arrival_delay, distance) %>%
  map(amplitude)

#using map_df in order to standardize the results of maps into a tibble

flights %>%
  select(departure_delay, arrival_delay, distance) %>%
  map_df(amplitude)

#using map in order to apply several read_csv to all the files in a single row

flights %>% filter(month==1 & day==1) %>% write_csv("flights_jan_01.csv")
flights %>% filter(month==1 & day==2) %>% write_csv("flights_jan_02.csv")

arquivos <- c("flights_jan_01.csv", "flights_jan_02.csv")

dados <- arquivos %>% map(read_csv)

#using set_names in order to name the elements into the list generated with map

dados <- arquivos %>%
  set_names() %>%
  map(read_csv)

#using bind_rows in order to vertically bind the tibbles

dados <- arquivos %>%
  map(read_csv) %>%
  bind_rows()

#or, alternatively, use map_df as showed above 
dados <- arquivos %>%
  map_df(read_csv)

#LISTS
#a list is a group of diverse objects vertically organized
#a list only has elements, blank boxes to keep whatever kind of object

objeto1 <- flights %>% filter(month==1 & day==1)
objeto2 <- 3.14
objeto3 <- flights %>% filter(month==1 & day==2)
objeto4 <- "teste"

lista_exemplo <- list(objeto1, objeto2, objeto3, objeto4)
lista_exemplo

lista_exemplo[[1]]
lista_exemplo[[2]]

#naming the objects

lista_exemplo_nomes <- list(tibble1=objeto1, 
                            numero=objeto2, 
                            tibble2=objeto3, 
                            string=objeto4)

lista_exemplo_nomes

lista_exemplo_nomes[["string"]]


#calculating the average delay per airport in january and february

flights_jan <- flights %>% filter(month==1)
flights_fev <- flights %>% filter(month==2)

flights_jan_fev <- list(janeiro=flights_jan, 
                        fevereiro=flights_fev)

flights_jan_fev %>% map(summarize, departure_delay=mean(departure_delay, na.rm=T))

#generating a tibble instead of a list

flights_jan_fev %>% map_df(summarize, departure_delay=mean(departure_delay, na.rm=T),
                                                           #specifying the name of the month
                           .id="Mês")

#Function	Input	Output
#map	Multiple Columns form a tibble (with select)	List
#map	a Vetor	List
#map	a List	List
#map_df	Multiple Columns form a tibble (with select) Tibble
#map_df	a Vetor	Tibble
#map_df	a List	Tibble

#FOR LOOPS

elementos <- c("departure_delay", "arrival_delay", "distance")

resultado <- c()

for (i in elementos) {
  resultado[i] <- flights %>% pull(i) %>% amplitude()
}

#using map inside mutate in order to keep the values inside the original tibble
#adding only one column

nested_data <- 
  tibble(day=c(1,2),
         file=c("flights_jan_01.csv", 
                "flights_jan_02.csv")) %>%
  mutate(content=map(file,read_csv))

nested_data

#repeating functions with nested tibbles

#we can use map in order to apply a function for each tibble separately
#e.g. let's add a new column in the tibble with the number of flights

nested_data <-
  nested_data %>%
  #using map_dbl since it is a unique numeric value
  mutate(num_flights=map_dbl(content,nrow))

#writing a function for each database
#summarizing the correlation between departure_delay and departure_time for each database
library(broom)
corr_function <- function(tibble) {
  tibble %>% 
    cor.test(~departure_delay + departure_time, data=.) %>%
    tidy()
}

nested_data <- nested_data %>%
  mutate(corr=map(content, corr_function))
#leaving only the central estimate of correlation visible

corr_function <- function(tibble) {
  tibble %>%
    cor.test(~departure_delay + departure_time, data=.) %>%
    tidy() %>%
    pull(estimate)
}

nested_data <- nested_data %>% 
  mutate(corr=map_dbl(content, corr_function))
nested_data


#Repeating analysis
#let's execute multiple regressions in a single line of code

flights %>%
  lm(departure_delay~departure_time, data=.)

nested_data <- nested_data %>%
  mutate(regression=map(content, ~lm(departure_delay~departure_time, data=.)))
#cleaning the results in order  to turn them more accessible
nested_data <- nested_data %>%
  mutate(regression=map(regression, tidy))

#extracting the coefficient of interest

nested_data <- nested_data %>%
  mutate(coef=map(regression, filter, term=="departure_time"),
         coef=map_dbl(coef,pull,estimate))

#applying distinct regressions per origin

flights_reg_per_origin <- flights %>%
  #preparing the appropriate tibble
  group_by(origin) %>%
  nest() %>%
  #executing the regression
  mutate(regression=map(data, ~lm(departure_delay~departure_time, data=.)),
         regression=map(regression,tidy),
         coef=map(regression,filter,term=="departure_time"),
         #extracting the value of interest
         coef=map_dbl(coef,pull,estimate))

#Mapping multiple arguments

nested_data <- nested_data %>% mutate(formula=c("departure_delay ~ departure_time",
                                                  "arrival_delay ~ departure_time"))

nested_data <- nested_data %>%
  mutate(results=map2(formula,content, lm))
nested_data