knn_model <- nearest_neighbor() %>%
  set_engine("kknn")%>%
  set_mode("classification") %>%
  set_args(neighbors = tune())


knn_workflow <- workflow() %>% 
  add_model(knn_model) %>% 
  add_recipe(recipe)

# define grid
knn_grid <- tibble(neighbors = seq(1, 50))

set.seed(111)
knn_res <- knn_workflow %>% 
  tune_grid(resamples = Glass_folds,
            grid = knn_grid
  )
save(knn_res, knn_workflow, file = "C:/Users/DELL/Desktop/131/final project/1002Rmodel/knn_res.rda")

set.seed(111)
load("C:/Users/DELL/Desktop/131/final project/1002Rmodel/knn_res.rda")
autoplot(knn_res, metric = "roc_auc") 
show_best(knn_res, metric = "roc_auc") %>% select(-.estimator, -.config)