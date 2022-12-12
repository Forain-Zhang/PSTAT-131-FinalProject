rf_model <- rand_forest() %>%
  set_mode("classification") %>%
  set_engine("ranger",importance = "impurity")%>%
  set_args( min_n = tune() )

rf_workflow <- workflow() %>% 
  add_model(rf_model) %>% 
  add_recipe(recipe)

# define grid  data is small,so only tune min_n
rf_grid <- tibble(min_n = seq(1, 40))

set.seed(111)
rf_res <- rf_workflow %>% 
  tune_grid(resamples = Glass_folds,
            grid = rf_grid
  )
save(rf_res, rf_workflow, file = "C:/Users/DELL/Desktop/131/final project/1002Rmodel/rf_res.rda")

set.seed(111)
load("C:/Users/DELL/Desktop/131/final project/1002Rmodel/rf_res.rda")
autoplot(rf_res, metric = "roc_auc")  
show_best(rf_res, metric = "roc_auc") %>% select(-.estimator, -.config) #min_n=1 mean=0.9535182

set.seed(111)
rf_workflow_tuned <- rf_workflow %>% 
  finalize_workflow(select_best(rf_res, metric = "roc_auc"))
rf_final <- fit(rf_workflow_tuned, trainingGlass)

set.seed(111)
#confusion
augment(rf_final, new_data = testingGlass) %>%
  conf_mat(truth = type, estimate = .pred_class) %>%
  autoplot(type = "heatmap")
#calculate accuracy
rf_acc <- augment(rf_final, new_data = testingGlass) %>%
  accuracy(truth = type, estimate = .pred_class)
rf_acc
#calculate auc 
rf_final_auc <- augment(rf_final, new_data = testingGlass) %>%
  roc_auc(type, estimate = .pred_1:.pred_7) %>%
  select(.estimate)  # computing the AUC for the ROC curve
rf_final_auc
