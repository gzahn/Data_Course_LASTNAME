# setup ####
library(tidyverse)
library(easystats)
library(tidymodels)
library(janitor)
library(vip)
theme_set(theme_minimal() + 
            theme(panel.grid = element_blank(),
                  axis.line = element_line(colour = "black"))
)

cores <- parallel::detectCores()

# load data
df <- read_csv("./Data/mushroom_growth.csv") %>% clean_names()
names(df)

# define terms ####
# set predictor variable name
response <- "growth_rate"
# select all remaning variables as predictors
predictors <- names(df)[names(df)!=response]

# subset to just those columns (redundant, but for safety)
df <- df[,c(response,predictors)]

# data splitting and resampling ####
set.seed(2022)
splits <- initial_split(df,strata = species,prop = .75)
train <- training(splits)
test <- testing(splits)

# tuning random forest model ####

# design model
rf_mod <- 
  rand_forest(mtry = tune(), min_n = tune(), trees = 1000) %>% 
  set_engine("ranger", num.threads = cores,importance="permutation") %>% 
  set_mode("regression")

# design recipe
rf_recipe <- 
  recipe(growth_rate ~ ., data = train) %>% 
  step_novel() # in case of previously unseen factor level

# build workflow
rf_workflow <- 
  workflow() %>% 
  add_model(rf_mod) %>% 
  add_recipe(rf_recipe)

rf_fit <- 
  rf_workflow %>% 
  fit(data=train)

# tuning grid
tree_grid <- 
  grid_regular(mtry(c(1,length(predictors))),
               min_n(),
               levels=3)
tree_grid

# make cross-val folds
set.seed(2022)
cv_folds <- 
  vfold_cv(train)

# tune model (run once for each combo of tuning params)
tree_res <- 
  rf_workflow %>% 
  tune_grid(resamples = cv_folds,
            grid = tree_grid)

tree_res

# pull best RF parameters ####
tree_res %>% 
  collect_metrics() %>% 
  ggplot(aes(x=mtry,y=mean,color=factor(min_n))) + 
  geom_point() + geom_line() +
  facet_wrap(~.metric,scales = "free",nrow=2)

best_tree <- 
  tree_res %>% 
  select_best("rmse")

final_workflow <- 
  rf_workflow %>% 
  finalize_workflow(best_tree)

final_fit <- 
  final_workflow %>%
  last_fit(splits)

final_fit %>% 
  collect_metrics()
final_fit %>% 
  collect_predictions()
final_tree <- 
  extract_workflow(final_fit)

# final Random forest model ####  
rf_params <- rand_forest(mode = "regression",
                         trees=2000,
                         mtry = best_tree$mtry, # 6 best_tree$mtry
                         min_n = best_tree$min_n) # 40 best_tree$min_n
rf_params


## build model ####
rf_xy_fit <- 
  rf_params %>% 
  set_engine("ranger",
             num.threads = cores,
             importance="permutation") %>% 
  fit_xy(
    x=train[,predictors],
    y=train[,response]
  )


rf_xy_fit


## predictions and testing ####

# make predictions for test data set
predictions <- predict(rf_xy_fit, new_data = test)


# compare predictions to reality in test data split
test$pred <- predictions$.pred

test %>% 
  ggplot(aes(x=growth_rate,y=pred)) +
  geom_point() +
  geom_smooth(method='lm')


# make predictions for whole data set
predictions <- predict(rf_xy_fit, new_data = df)

df$pred <- predictions$.pred

df %>% 
  ggplot(aes(x=growth_rate,y=pred)) +
  geom_point() +
  geom_smooth(method='lm')

## extract model info and parameters ####
extract_fit_engine(rf_xy_fit) %>% 
  vip()

# r-squared value
rf_xy_fit$fit$r.squared

# find variable levels for max growth rate prediction
df %>% 
  filter(pred == max(pred)) %>% 
  select(predictors)

# predictions on hypothetical data ####
hyp_data <- data.frame(species="P.ostreotus",
                       light=10,
                       nitrogen=0,
                       humidity="low",
                       temperature=20)
predict(rf_xy_fit,new_data = hyp_data)
