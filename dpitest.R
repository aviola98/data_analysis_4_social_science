library(tidyverse)
library(dplyr)
library(haven)
dpi_2020<- read_dta("DPI2020.dta")

View(dpi_2020)
#filtering the data for brazil only
brazil_dpi <- filter(dpi_2020, countryname == "Brazil")
View(brazil_dpi)

#years in office x party
ggplot(data = brazil_dpi,
       mapping = aes(x = execme,
                     y = yrsoffc
                     ))+
  geom_col(fill = "blue", width = 0.5)

  