#the graph's grammar

library(tidyverse)
library(tidylog)
library(nycflights13)

#we start with our dataset then we filter what is interesting to us, the last pipe passes the tibble to the ggplot function. We can then proceed to add the layers needed to our graph (we use + insead of %>%) 

flights %>% filter(destination=="DEN") %>%
  ggplot() +
  geom_point(aes(x=dep_time, 
                 y=dep_delay),
             size=1)

#visual elements of a graph
#aesthetics

# x = x axis
# y = y axis
#color/colour = the color of the point/line/poligon
#fill=color inside an area/barr
#alpha= transparency
#shape=shape of the observation
#size=size of the observation
#linetype= if the lyne is filled, dotted or dashed
#label=text

#there are two ways we can specify the aestetics of a layer, depending on wether we want the aestetics to vary according to our data or to be fix and constant for all observations


#for the aestetics that vary accordingly to our data (e.g. the color depends on the air company) we define the aestetic as a variable inside the aes function

flights %>%
  ggplot() +
  geom_point(aes(x=departure_time, y=departure_delay, shape=origin, 
                 size=distance, color=carrier))

#for aestetics thar DO NOT vary accordingly to our data (e.g. the size is fixed) we define the aestetic as a unique value (a constant instead of a variable) outside of the aes function

flights %>%
  ggplot()+
  geom_point(size=10, aplha=0.7)

#geometries

#geom_bar  (a discrete variable i.e. the number of observations per group) 
#geom_histogram (a continuous variable, x)
#geom_density (a continuous variable, x)
#geom_point (2 continuous variables, x and y)
#geom_histogram (a continuous variable and a discrete variable, x and fill)
#geom_density (a continuous variable and a discrete variable, x and colour)
#geom_boxplot (a continuous variable and a discrete variable, x and y)
#geom_col (a continuous variable and a discrete variable, x and y)
#geom_line (a continuous variable and a discrete ordered variable, x, y and group)
#geom_point (2 continuous variables and a discrete variable, x,y and color/shape/size)

##Geometry for a discrete variable (the number of observations in a group)

flights %>%
  ggplot() +
  geom_bar(aes(x=origin))

#Geometry for graphs with a continuous variable (Histograms)
#increasing the width of the histograms representing more values on the x axis
#bindwitdth is specified outside the aes because fix parameters that do not depend on our data must stay outside aes
#adding color, color specifies the color of the borders and fill the area
flights %>%
  mutate(speed=distance/air_time) %>%
  ggplot() +
  geom_histogram(aes(x=speed), binwidth = 1,
                 color="black",
                 fill="orange") 

#graphs with a continuous variable (density graphs)
#alpha is used in order to improve the transparency of the graph
flights %>%
  mutate(speed=distance/air_time) %>%
  ggplot () +
  geom_density(aes(x=speed), color="blue",
               fill="blue",
               alpha=0.2)

#adding a reference in order to facilitate the graph's interpretation, in this case a vertical line that indicates where is the mean of the distribution

speed_mean <- flights %>%
  mutate(speed=distance/air_time) %>%
  summarize(speed_mean=mean(speed, na.rm=T)) %>% 
  pull(speed_mean)

#adding the intercept (xintercept) 

flights %>%
  mutate(speed=distance/air_time) %>%
  ggplot() +
  geom_density(aes(x=speed), 
               color="blue",
               fill="blue",
               alpha=0.2) +
  geom_vline(aes(xintercept=speed_mean),
             linetype="dashed",
             color="red")

#graph with a continuous variable and a discrete variable 

#comparing a continuous variable among sub-layers (e.g. dep_time per origin)

flights %>%
  ggplot() +
  geom_histogram(aes(x=dep_time,
                     fill=origin),
                 position = "dodge",
                 binwidth = 200)
#I used postion = dodge in order to organize the data side-by-side

#the same graph but density
#instead of fill let's use origin as a parameter for color inside aes and separate
#the distribution by border color

flights %>%
  ggplot() +
  geom_density(aes(x=dep_time,
                   color=origin))

#the same graph but with fill

flights %>%
  ggplot() +
  geom_density(aes(x=dep_time,
                   fill=origin),
               alpha=0.5)



#the same graph with fill and color together

flights %>%
  ggplot() +
  geom_density(aes(x=dep_time, 
                   color=origin,
                   fill=origin),
               alpha=0.5)


#graphs with a continuous variable and a discrete variable (Boxplot)

flights %>%
  ggplot() +
  geom_boxplot(aes(x=origin,
                   y=dep_time))
#describes the distribution of the continuous variable in the y axis with a boxplot that summarizes the relevant statistics of the distribution


#Graphs with a single value for a discrete variable (Column graphs)

flights %>%
  group_by(origin) %>%
  summarize(avg_dep_delay=mean(dep_delay, na.rm=T)) %>%
  ggplot() +
  geom_col(aes(x=origin,
               y=avg_dep_delay))

#there is a difference between geom_col and geom_bar
#geom_col shows the value to the y axis based on the values in a column of your tibble
#geom_bar generates the values for the y axis based on the number of observations in each group of your tibble

#graph with two continuous variables

#note: in case your pc is slow you can take a random sample of 1000 rows  from the dataset

flights %>%
  sample_n(1000) %>%
  ggplot() +
  geom_point(aes(x=distance,
                 y=air_time))

#each dot represents a flight , obviously the more distant the flight the longer it takes

#we can personalize the graph by adding colors size and shape to the dots

flights %>% sample_n(1000) %>% 
  ggplot() + 
  geom_point(aes(x = distance,
                 y = air_time), 
             size=0.1,
             color="blue",
             shape=2)

#we can use geom_smooth in order to summarize the relationship between these 2 variables in linear models
#we need to define what is the method to modeling the data (the most common method is a linear model)

flights %>%
  sample_n(1000) %>%
  ggplot() +
  geom_point(aes(x=distance,
                 y=air_time),
             size=0.1) +
  geom_smooth(aes(x=distance,
                  y=air_time),
              method="lm",
              se=FALSE)

#if we remove the "se" parameter we have the confidence interval of the line we insterted
#we decrease the n in order to make the confidence interval even more visible

flights %>%
  sample_n(50) %>%
  ggplot() +
  geom_point(aes(x=distance,
                 y=air_time),size=0.1) +
  geom_smooth(aes(x=distance,
                  y=air_time),
              method="lm")
#a non linear alternative to represent the data tendencies is the method loess(local weighted regression) in this case it doesn't vary much due to the linear tendence of the data

flights %>% sample_n(1000) %>% ggplot() + 
  geom_point(aes(x = distance, y = air_time), size=0.1) +
  geom_smooth(aes(x = distance, y = air_time), method = "loess")


#graphs with three or more variables

#in general, when we want to show more information we add other geometry parameters such as color, size and shape inside the aes in a third variable 

#if we, for example, want to represent a third continuous variable we can add it as the size of the dots (circle radius)

#e.g. a graph comparing dep_time and dep_delay where the distance is represented by the dot's size 

flights %>%
  sample_n(1000) %>%
  ggplot() +
  geom_point(aes(x=departure_time,
                 y=departure_delay,
                 size=distance))

#if instead of changig the size of a numeri variable we want to change the color or the shape of a categoric variable (e.g. origin) we can do:

flights %>%
  sample_n(1000) %>%
  ggplot() +
  geom_point(aes(x=departure_time,
                 y=departure_delay,
                 color=origin))

flights %>%
  sample_n(1000) %>%
  ggplot() +
  geom_point(aes(x=departure_time,
                 y=departure_delay,
                 shape=origin))


#multiple graphs 
#facet_grid

#horizonal
flights %>%
  sample_n(100) %>%
  ggplot() +
  geom_point(aes(x=departure_time,
                 y=departure_delay)) +
  facet_grid(cols=vars(origin))
#vertical 

flights %>%
  sample_n(100) %>%
  ggplot() +
  geom_point(aes(x=departure_time,
                 y=departure_delay))+
  facet_grid(rows=vars(origin))

#separating graphs with a horizontal variable and a vertical variable
#this graph shows the relationship between the departure time and the delay per month and the airport (each element is an origin airport and a month)

flights %>%
  sample_n(100) %>%
  ggplot() +
  geom_point(aes(x=departure_time,
                 y=departure_delay)) +
  facet_grid(rows = vars(month),
             cols = vars(origin))

#Line graphs
#a line graph needs special preparation of our data
#the x variable can be discrete or continuous but it needs to be ordered so that the lines can make sense

#let's analize the delay per month 
#fist we need to summarize the data per month and in order to do so the first step is to transform the month variable into an ordered factor, then we calculate the delay per month

flights %>%
  mutate(month=factor(month, levels=1:12, ordered = T)) %>%
  group_by(month) %>%
  summarize(departure_delay_mean=mean(departure_delay, na.rm=T)) %>%
  #Now that we've orderer the data in the appropriate way (month as the analysis unit and the average departure delay available) let's create the line graph :p
  ggplot() +
  geom_line(aes(x=month,
                y=departure_delay_mean),
            group = 1)

#we used the group here in order to define how to join the dots over time (in this case we have only one group/line so we can put group=1)

#separating airport by line
flights %>% 
  mutate(month=factor(month, levels=1:12, ordered=T)) %>%
  group_by(month, origin) %>%
  summarize(dep_delay_media=mean(departure_delay,na.rm=T)) %>%
  ggplot() +
  geom_line(aes(x=month, 
                y=dep_delay_media, 
                group=origin,
                color=origin))


#bar graph 
#this kind of graph is useful to understand the participation of a group in  the total
#for example let's calculate the contribution of each airport to the total delay of each month 
flights %>%
  mutate(month=factor(month,levels=1:12,ordered=T)) %>%
  group_by(month,origin) %>%
  summarize(dep_delay_tot=sum(departure_delay,na.rm=T)) %>%
  ggplot() +
  geom_col(aes(x=month,
               y=dep_delay_tot,
               fill=origin),
           position="fill")

#more geometries

#geom_text 
#it puts in a geometrical shape the text itself 
#e.g. we can specificate a dispersion graph were the points reflect the name of the flight destiny using the parameter label

flights %>%
  sample_n(100) %>%
  ggplot() +
  geom_text(aes(x=departure_time,
                y=departure_delay,
                label=destination))

#geom_tile

#analyzing the average delay by airport per month

flights %>%
  group_by(origin,month) %>%
  summarize(dep_delay_mean=mean(departure_delay, na.rm = T)) %>%
  ggplot() +
  geom_tile(aes(x=origin,
                y=month,
                fill=dep_delay_mean))

#pizza graph 
#first let's use geom_col with position=fill in order to make sure the value are 100% and let's leave the x aesthetic null because we only want one barr

flights %>%
  group_by(origin) %>%
  summarize(dep_delay_total=sum(departure_delay, na.rm=T)) %>%
  ggplot()+
  geom_col(aes(x="",
               y=dep_delay_total,
               fill=origin),
           position="fill")
#in order to transform this graph into a circle we need to understand that beyond gemoetry and aesthetics the graphs also have a coordenate system.
#usually these are obvious and don't need to be specified into the graph (x and y axis) but when it comes to the circle

flights %>%
  group_by(origin) %>%
  summarize(dep_delay_total=sum(departure_delay, na.rm=T)) %>%
  ggplot()+
  geom_col(aes(x="",
               y=dep_delay_total,
               fill=origin),
           position="fill")+
  coord_polar(theta="y")


#controlling colors with scales

#coloring a dot/line (color)
#filling an area (fill)

#continuous variable: scale_color_gradient(low="cor1",high="cor2") 
#discrete variable: scale_color_brewer(palette="pre-defined")
#continuous variable: scale_fill_gradient(low="cor1", high="cor2")
#discrete variable: scale_fill_brewer(palette="pre-defined")

#always consult COLOR BREWER 

#e.g. continuous variable (dep_time) 

flights %>%
  sample_n(1000) %>%
  ggplot()+
  geom_point(aes(x=distance,
                 y=air_time,
                 color=dep_time)) +
  #adding a personalized scale based on BREW COLOR
  scale_color_gradient(low="#f7fcfd",
                       high="#238b45")

#discrete variables are a bit harder cuz we have to specify the distinct color for each possible category
#we can use a pre-defined palette 
#e.g. using set2

flights %>%
  sample_n(1000) %>%
  ggplot()+
  geom_point(aes(x=distance,
                 y=air_time,
                 color=origin)) +
  scale_color_brewer(palette="Set2")

#using fill in order to color an area

flights %>%
  group_by(origin,month) %>%
  summarize(dep_delay_mean=mean(departure_delay,na.rm=T)) %>%
  ggplot() +
  geom_tile(aes(x=origin,
                y=month,
                fill=dep_delay_mean)) +
  scale_fill_gradient(low="#f7fcfd",
                      high="238b45")


#e.g. discrete variable

flights %>%
  group_by(origin,month,carrier) %>%
  tally() %>%
  group_by(origin,month) %>%
  filter(n==max(n)) %>%
  ggplot() +
  geom_tile(aes(x=origin,
                y=month,
                fill=carrier)) +
  scale_fill_brewer(palette="Set2")


#personalizing graphs beyond geometry

#adding a title 

flights %>% sample_n(1000) %>% ggplot() + 
  geom_point(aes(x = distance, y = air_time, color=origin)) +
  #adding title
  ggtitle("Relationship between distance and flight duration by NY airport") +
  #adding variable name
  xlab("Distance") +
  ylab("Duration") +
  #changing legend position
  theme(legend.position="bottom",
        #changing axis size
        axis.text.x=element_text(size=4) ,
        axis.text.y=element_text(size=4),
        axis.title.x=element_text(size=4),
        axis.title.y=element_text(size=4))

#we can also use a pre-defined theme
#e.g. theme_classic()

flights%>%
  sample_n(1000) %>%
  ggplot() +
  geom_point(aes(x=distance,
                 y=air_time,
                 color=origin))+
  ggtitle("Relationship between distance and flight duration by NY airport") +
  xlab("Distance") +
  ylab("Duration") +
  theme_classic()

library(ggthemes)
#using themes from this library
#the economist style

flights %>% sample_n(1000) %>% ggplot() + 
  geom_point(aes(x = distance, y = air_time, color=origin)) +
  ggtitle("Relação entre distância e duração de voo, por aeroporto do Nova Iorque") +
  xlab("Distância") +
  ylab("Duração") +
  theme_economist()

#iterative graphs

library(plotly)

#first we save our graph with the same sintax as ggplot

graf_1 <- flights %>% sample_n(1000) %>% ggplot() + 
  geom_point(aes(x = distance, y = air_time, color=origin)) +
  ggtitle("Relação entre distância e duração de cada voo, por aeroporto do Nova Iorque em 2013") +
  xlab("Distância") +
  ylab("Duração") +
  theme_classic() 

graf_1 %>%
  ggplotly()

#we can also turn graphs into animation
#we need to specify into the frame parameter the variable that defines the moment and timing of the animation

graph_2 <- flights %>% sample_n(1000) %>% ggplot() + 
  geom_point(aes(x = distance, y = air_time, color=origin, frame=month)) +
  ggtitle("Relação entre distância e duração de cada voo, por aeroporto do Nova Iorque em 2013") +
  xlab("Distância") +
  ylab("Duração") +
  theme_classic() 

graph_2 %>%
  ggplotly()
