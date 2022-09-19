
readLines()
list.files()
read.csv()
c()
head()
length()
for(var in vectorofstuff){}
plot() # plot(x=df$mass,y=df$wingspan)

sum(df$wingspan)
mean(df$wingspan)
median(df$wingspan)
sd(df$wingspan)
min(df$wingspan)
max(df$wingspan)

summary(df$wingspan)


median(c("your mom","your dad"))
median(c("1","5"))
median(c(1:5))


library(tidyverse)
df %>% 
  ggplot(aes(x=mass,y=wingspan,color=variety)) +
  geom_point() +
  geom_smooth(color="black") 

