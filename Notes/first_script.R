# finding files
list.files()


x <- 5


?list.files
x <- list.files(recursive = TRUE,include.dirs = TRUE,
           full.names = TRUE,pattern = "ugly",ignore.case = TRUE,
           path = "~/Desktop")

x <- list.files(pattern=".csv",recursive = TRUE,full.names = TRUE)
x[1]
y <- x[1]
?readLines
readLines(y)[1:3]

?read.csv

z <- read.csv(y)

z$IATA_CODE[c(1,3)]

myvec <- c(1,3,5,7,9)
z$IATA_CODE[myvec]


list.files(recursive = TRUE,pattern = "grade",ignore.case = TRUE,
           full.names = TRUE)

grades <- read.csv("./Data/Fake_grade_data.csv")
class(grades)

# data frames with [] : [row,col]
grades[2,2]
# row 3 , columns 1,3,5
grades[3,c(1,3,5)]

a <- c(TRUE,TRUE,FALSE)


# list of students who have  > 15 on ass 1

grades$Assignment_1 > 15

grades$Student[grades$Assignment_1 > 15]




"^csv"
"csv$"
"*csv$"

c("a",2,3) + 1





library(tidyverse)
grades %>% 
  filter(Assignment_1 > 15) %>% 
  select(Student)


x
c("a","c","e")



# 
# 1 / FALSE
# TRUE + 1
# FALSE + 1
# 
# true + 1



1+1 # adding two numbers
