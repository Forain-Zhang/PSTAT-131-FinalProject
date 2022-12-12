theme <- theme(plot.title = element_text(hjust = 0.3, face = "bold"))

glass%>%
  ggplot(aes(x = type, 
             y = stat(count), fill = type,
             label = scales::comma(stat(count)))) +
  geom_bar(position = "dodge") + 
  geom_text(stat = 'count',
            position = position_dodge(.9), 
            vjust = -0.5, 
            size = 3) + 
  scale_y_continuous(labels = scales::comma)+
  labs(x = 'glass type', y = 'Count') +
  ggtitle("Distribution of glass type") +
  theme

ggplot(glass, aes(x = type, colour = type)) + 
  geom_density(aes(group = type, fill = type), alpha = 0.3) +
  labs(title = "Distribution of glass each type")

corr <- cor(glass0)
corrplot(corr,tl.cex = 0.8, number.cex = 0.8, method = "number",title ='correlation matrix')

glass %>%
  ggplot(aes(x = type, y = mg,fill = type)) + 
  geom_boxplot() + 
  labs(x = 'glass type', y = 'Mg') +
  ggtitle("Boxplot of Mg by glass type") +
  theme

glass %>%
  ggplot(aes(x = type, y = al,fill = type)) + 
  geom_boxplot() + 
  labs(x = 'glass type', y = 'Al') +
  ggtitle("Boxplot of Al by glass type") +
  theme