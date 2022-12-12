set.seed(111)
split_data <-glass %>% 
  initial_split(glass,prop = 0.8, strata = "type")
trainingGlass <- training(split_data)
testingGlass <- testing(split_data)
dim(trainingGlass) # 170  10
dim(testingGlass)  # 44 10
dim(glass)

Glass_folds <- vfold_cv(trainingGlass, v = 2,repeats = 3)  
recipe<-trainingGlass %>%
  recipe(type ~ri+na+mg+al+si+k+ca+ba+fe) %>%
  step_normalize(all_predictors()) #Center and scale all predictors
recipe

log_model <- logistic_reg() %>% 
  set_engine("LiblineaR")%>% 
  set_mode('classification')%>%
  set_args(penalty = tune())

log_workflow <- workflow() %>% 
  add_model(log_model) %>% 
  add_recipe(recipe)

log_grid <- tibble(penalty = 10^seq(-3, -1, length.out = 20))

log_res <- log_workflow %>% 
  tune_grid(resamples = Glass_folds,
            grid = log_grid,
            control = control_grid(save_pred = TRUE),
            metrics = metric_set(roc_auc))

save(log_res, log_workflow, file = "C:/Users/DELL/Desktop/131/final project/1002Rmodel/log_res.rda")

load("C:/Users/DELL/Desktop/131/final project/1002Rmodel/log_res.rda")
autoplot(log_res, metric = "roc_auc")  ##0.001 best
show_best(log_res, metric = "roc_auc") %>% dplyr::select(-.estimator, -.config)
#penalty=0.02976351	mean=0.8705329