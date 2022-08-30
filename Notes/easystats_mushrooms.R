# setup ####
library(tidyverse)
library(easystats)
library(modelr)
library(janitor)
theme_set(theme_minimal() + 
            theme(panel.grid = element_blank(),
                  axis.line = element_line(colour = "black"))
          )

# load data
df <- read_csv("./Data/mushroom_growth.csv") %>% clean_names()
names(df)

# examine response
df %>% 
  ggplot(aes(x=growth_rate)) +
  geom_density()

# transform response to 'normalize'
df <- df %>% 
  mutate(log_growth_rate = log10(growth_rate))


# first model ####
# model on transformed response
mod <- glm(data = df,
           formula = log_growth_rate ~ species * (light + nitrogen + humidity + temperature))

# model dashboard
model_dashboard(mod)

# check out model
check_model(mod)
performance(mod)
report(mod)

# estimate marginal means (when other stuff held constant)
estimate_means(mod) %>% 
  data.frame() %>% 
  mutate(Mean = 10^Mean)
estimate_means(mod) %>% plot()


# compare models ####

# stepwise simplification of original model
step <- MASS::stepAIC(mod)
mod2 <- glm(data = df,
            formula = step$formula)


# polynomial term
mod3 <- glm(data = df,
           formula = log_growth_rate ~ species * (light + poly(nitrogen,2) + humidity + temperature))

# simplified
step <- MASS::stepAIC(mod3) 
mod4 <- glm(data = df,
            formula = step$formula)

# compare performance
compare_performance(mod,mod2,mod3,mod4,rank = TRUE)
compare_performance(mod,mod2,mod3,mod4) %>% plot()
test_performance(mod3,mod4)
formula(mod3)
formula(mod4)


# pick 'best' model
mods <- compare_performance(mod,mod2,mod3,mod4,rank = TRUE) %>% 
  data.frame() %>% pluck("Name")
best_mod <- get(mods[1])

model_dashboard(best_mod)
parameters(best_mod)

estimate_expectation(model = best_mod,data = df) %>% 
  data.frame() %>% 
  mutate(Predicted = 10^Predicted)
 
df$pred <- estimate_expectation(model = best_mod,data = df) %>% 
  data.frame() %>% 
  mutate(Predicted = 10^Predicted) %>% 
  pluck("Predicted")

df %>% 
  ggplot(aes(x=growth_rate,y=pred)) +
  geom_point() +
  geom_smooth(se=FALSE, color="Red", method="lm", linetype=2)

df$pred <- NULL

gather_predictions(df,mod,mod2,mod3,mod4) %>% 
  mutate(pred=10^pred) %>% 
  ggplot(aes(x=growth_rate,y=pred)) +
  geom_point() +
  geom_smooth() +
  facet_wrap(~model)
