#tibble 
#tibbles are data frames 

library(tidyverse)

#coercing a data frame to a tibble

as_tibble(iris)

#creating a new tibble

tibble(
  x=1:5,
  y=1,
  z=x^2+y
)

#subsetting
#in order to extract a single variable from a tibble
#you need to use $ and [[]], the first one extracts by name
#while the first one extracts by both name and position

df <- tibble(
  x=runif(5),
  y=rnorm(5)
)
#extract by name
df$x
df[["x"]]
#extract by position
df[[1]]


#to use these in a pipe you'll need to use the special
#placeholder "."

df %>% .$x
df %>% .[["x"]]

#converting a tibble into a data frame

class(as.data.frame(tb))

#exercises

#1-How can you tell if an object is a tibble? (Hint: try printing mtcars, which is a regular data frame).
print(mtcars)

#You know when an object is a tibble when it only shows you
#the first ten observations and the class of each variable

#2-Compare and contrast the following operations on a data.frame and equivalent tibble. What is different? Why might the default data frame behaviours cause you frustration?

df <- data.frame(abc=1, xyz = "a")
df$x
df[, "xyz"]
df[,c("abc","xyz")]


tbl <- as_tibble(df)
tbl$x
tbl[,"xyz"]
tbl[,c("abc","xyz")]

#the $ operator will match any column name that starts with the name following it. but it may cause frustration since you can accidentally use a different column that you thought you were using

#3-If you have the name of a variable stored in an object, e.g. var <- "mpg", how can you extract the reference variable from a tibble?

#use var[["mpg"]] but not $cuz it will look for a column named mpg

#4-Practice referring to non-syntactic names in the following data frame by:
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

#Extracting the variable called 1.
annoying$`1`

#Plotting a scatterplot of 1 vs 2.
ggplot(annoying, aes( x = `1`, y=`2`)) +
  geom_point()
#Creating a new column called 3 which is 2 divided by 1.
annoying <- mutate(annoying, `3`= `2`/`1`)
#Renaming the columns to one, two and three.
annoying <- rename(annoying, one = `1`,two = `2`,
                   three = `3`)
glimpse(annoying)

#5-What does tibble::enframe() do? When might you use it?
#it converts named vectors to a data frame with names and values
enframe(c(a=1,b=2,c=3))
