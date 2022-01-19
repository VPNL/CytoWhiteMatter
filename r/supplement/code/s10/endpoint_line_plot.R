endpoint_line_plot <- function(df,agegroup) {
  # inputs: df with endpoint connectivity profile 
  #         agegroup - 'kid' or 'adult' 
  # outputs: line plot colored by roi in supplementary fig 10ab
  plt <- df %>%
    filter(group == agegroup,
           roi %in% c("mFus-faces", "pFus-faces", "pOTS-words")) %>%
    ggplot(aes(x = roi_code,
               y = endpoint_proportion,
               color = roi)) +
    geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs")) +
    ylab("Mean Endpoint Proportion") +
    xlab("Glasser ROI") +
    theme(
      text = element_text(size = 14),
      axis.ticks.x = element_blank(),
      legend.position = "none",
      aspect.ratio = 2,
      element_line(size = 1)
    ) +
    scale_color_manual(values = c("#ff9999", "#ff0000", "#0000FF")) +
    coord_cartesian(ylim = c(0, .00006), xlim = c(0, 180)) +
    geom_segment(aes(
      x = 0,
      y = -.000002,
      xend = 73,
      yend = -.000002
    ),
    colour = "#cc0000",
    size = 3) +
    geom_segment(
      aes(
        x = 73,
        y = -.000002,
        xend = 73 + 47,
        yend = -.000002
      ),
      colour = "#e57f00",
      size = 3
    ) +
    geom_segment(
      aes(
        x = 73 + 47,
        y = -.000002,
        xend = 73 + 47 + 39,
        yend = -.000002
      ),
      colour = "#cc4ccc",
      size = 3
    ) +
    geom_segment(
      aes(
        x = 73 + 47 + 39,
        y = -.000002,
        xend = 73 + 47 + 39 + 21,
        yend = -.000002
      ),
      colour = "#99cc19",
      size = 3
    )
  
  plt
}
  
