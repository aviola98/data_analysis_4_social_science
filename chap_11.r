#data import

library(tidyverse)

#1-What function would you use to read a file where fields were separated with
#“|”?
  
read_delim(file, delim = "|")

#2-Apart from file, skip, and comment, what other arguments do read_csv() and read_tsv() have in common?

#They have the same arguments, the only difference is that
#the first one is comma delimited and the second one is tab delimited

#3-What are the most important arguments to read_fwf()?

#fwf_widths()-specifies fields by their widths
#fwf_positions()- specifies fields by their position 
#read_table - reads a common variation of fixed width files
#where columns are separated by white space

#4-Sometimes strings in a CSV file contain commas. To prevent them from causing problems they need to be surrounded by a quoting character, like " or '. By default, read_csv() assumes that the quoting character will be ". What argument to read_csv() do you need to specify to read the following text into a data frame?

x<-"x,y\n1,'a,b'"

read_delim(x, ",", quote = "'")
#or
read_delim(x,quote="'")

#Parsing a vector 
#parse function take a character vector and return a more specialied one, examples are shown below
#returns a logical vector
str(parse_logical(c("TRUE","FLASE","NA")))
#returns an integer vector
str(parse_integer(c("1","2","3")))
#returns a date vector
str(parse_date(c("2010-01-01","1979-10-14")))

#use na= to specify which strings should be treated as missing
parse_integer(c("1","2",".","456"), na = ".")

#number

#locale
parse_double("1.23")
parse_double("1,23", locale = locale(decimal_mark = ","))
#parse_number ignores non-numeric characters before and after the number
parse_number("$100")
parse_number("20%")
parse_number("It costs $123.45")
#parse_number + locale
#US
parse_number("$123,456,789")
#EVROPA
parse_number("123.456.789",locale = locale(grouping_mark = "."))
#Switzerland
parse_number("123'456'789", locale = locale(grouping_mark = "'"))

#strings
#ASCII
charToRaw("André")
charToRaw("Aziz")

#UTF-8 and encoding different languages
#Spanish (western european languages in general)
x1 <- "El Ni\xf1o was particularly bad this year"
parse_character(x1, locale = locale(encoding = "Latin1"))

#Japanese 
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

#guess_encoding

guess_encoding(charToRaw(x1))

#date, date-times and times

#parse_datetime() expects an ISO8601 date-time, i.e. 
#is an international standard in which the components of a date are organised from biggest to smallest
#year, month, day, hour, minute, second

parse_datetime("2010-10-01T2010")
parse_datetime("20101010")

#parse_date expects a four digit year, a - or /, the month, a - or /, then the day
parse_date("2010-10-01")

#parse_time expects the hour, :, minutes, optionally : and seconds and an optional am/pm specifier
library(hms)
parse_time("01:10 am")
parse_time("20:10:01")

#testing parsing functions
parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
parse_date("01/02/15", "%y/%m/%d")

#If you’re using %b or %B with non-English month names, you’ll need to set the lang argument to locale(). See the list of built-in languages in date_names_langs(), or if your language is not already included, create your own with date_names().

parse_date("1 gennaio 2007", "%d %B %Y", locale = locale("it"))

#Generate the correct format string to parse each of the following dates and times:

d1 <- "January 1, 2010"
parse_date(d1, "%B %d, %Y")
d2 <- "2015-Mar-07"
parse_date(d2, "%Y-%b-%d")
d3 <- "06-Jun-2017"
parse_date(d3, "%d-%b-%Y")
d4 <- c("August 19 (2015)", "July 1 (2015)")
parse_date(d4, "%B %d (%Y)")
d5 <- "12/30/14" # Dec 30, 2014
parse_date(d5, "%m/%d/%y")
t1 <- "1705"
parse_time(t1, "%H%M")
t2 <- "11:15:10.12 PM"
parse_time(t2, "%I:%M:%OS %p")


#Parsing a file


