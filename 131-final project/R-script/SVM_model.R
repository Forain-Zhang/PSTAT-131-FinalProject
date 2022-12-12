svm_model <- svm_rbf() %>%
  set_engine("kernlab")%>%
  set_mode('classification')%>% 
  set_args(cost  = tune())

svm_workflow <- workflow() %>% 
  add_model(svm_model) %>% 
  add_recipe(recipe)

svm_grid <- tibble(cost = 10^seq(-3, 0, length.out = 20))

set.seed(111)
svm_res <- svm_workflow %>%
  tune_grid(resamples =Glass_folds,
            grid = svm_grid)
save(svm_res, svm_workflow, file = "C:/Users/DELL/Desktop/131/final project/1002Rmodel/svm_res.rda")  

set.seed(111)
load("C:/Users/DELL/Desktop/131/final project/1002Rmodel/svm_res.rda")
autoplot(svm_res, metric = "roc_auc")  
show_best(svm_res, metric = "roc_auc") %>% select(-.estimator, -.config) #cost=1 mean=0.7976189	 