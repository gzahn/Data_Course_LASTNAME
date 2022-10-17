library(tidyverse)

df <- read_delim("./data/DatasaurusDozen.tsv")

p <- df %>% 
  ggplot(aes(x=x,y=y)) +
  geom_point() +
  facet_wrap(~dataset)
p

ggsave("./output/myplot.png",device = "png")
