classification_plot <- function(df){
a <-df %>%
  filter(classified_by %in% c('Cytoarchitecture','Category'),
         Group %in% c("Children","Adults")) %>%
    mutate(classified_by =
             fct_relevel(classified_by,
                         c('Cytoarchitecture', 'Category')),
           Group = fct_relevel(Group,c("Children","Adults"))) %>%
    ggplot(aes(x = classified_by,
               y = Accuracy,
               fill = Group)) +
    stat_summary(
      fun = "mean",
      geom = "bar",
   #   color = "gray",
  #    fill = "white",
      size = 1,
   position = position_dodge(.9)
    ) +
    stat_summary(
      fun.data = "mean_se",
      geom = "linerange",
    #  color = "black",
      size = 1,
     position = position_dodge(.9)
    ) +
    theme(
      axis.title.x = element_blank(),
      legend.position = "right",
      legend.text=element_text(size=8),
      legend.title=element_text(size=10),
      aspect.ratio = 1,
      text = element_text(size = 14),
      element_line(size = 1)
    ) +
    ylim(0, 100) +
    ylab("Classification Accuracy") +
    geom_segment(aes(
      x = .5,
      y = 50,
      xend = 2.5,
      yend = 50
    ),
    linetype = 'dashed',
    size = 1) +
    scale_x_discrete(
      breaks = c("Cytoarchitecture", "Category", "ROI"),
      labels = c("Cyto", "Category", "ROI")
    ) +
  scale_fill_manual(values =c('#deebf7','#3182bd'))

b <- df %>%
  filter(classified_by %in% c('ROI'),
          Group %in% c("Children","Adults")) %>%
    mutate(
           Group = fct_relevel(Group,c("Children","Adults"))) %>%
    ggplot(aes(x = classified_by,
               y = Accuracy,
               fill = Group)) +
    stat_summary(
      fun = "mean",
      geom = "bar",
      size = 1,
   position = position_dodge(.9)
    ) +
    stat_summary(
      fun.data = "mean_se",
      geom = "linerange",
    #  color = "black",
      size = 1,
     position = position_dodge(.9)
    ) +
    theme(
      axis.title.x = element_blank(),
      legend.position = "right",
      aspect.ratio = 2,
      text = element_text(size = 14),
      element_line(size = 1)
    ) +
    ylim(0, 100) +
    ylab("Classification Accuracy") +
    geom_segment(aes(
      x = .5,
      y = 25,
     xend = 1.5,
      yend = 25
    ),
    linetype = 'dashed',
    size = 1) +
  scale_fill_manual(values =c('#deebf7','#3182bd'))

a
}
