endpoint_line_plot <- function(df,agegroup){
  plt <- df %>% 
    filter(group == agegroup,
           roi %in% c("mFus-faces","pFus-faces","pOTS-words")) %>%
    ggplot(aes(x = roi_code,
                  y = endpoint_proportion,
                  color = roi)) +
                  geom_segment(aes(x = 73,
                                   y = -.000005,
                                   xend = 73,
                                   yend = .00008),
                                   colour = "#000000",
                                   size = .25,
                                   linetype = 2)+
                  geom_segment(aes(x = 73+47,
                                   y = -.000005,
                                   xend = 73+47,
                                   yend = .00008),
                                   colour = "#000000",
                                   size = .25,
                                   linetype = 2) +
                geom_segment(aes(x = 73+47+39,
                                   y = -.000005,
                                   xend = 73+47+39,
                                   yend = .00008),
                                   colour = "#000000",
                                   size = .25,
                                   linetype = 2) +
    geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs")) +
    ylab("Mean Endpoint Proportion") +
    xlab("Glasser ROI")+
    theme( text = element_text(size=14),
           axis.ticks.x=element_blank(),
           legend.position = "none",
           aspect.ratio = 2,
           element_line(size = 1)) +
    scale_color_manual(values =c(	"#ff9999","#ff0000","#0000FF")) +
    coord_cartesian(ylim = c(-.000005,.00008), xlim = c(0,180)) +
    geom_segment(aes(x = 0, 
                     y = -.0000085, 
                     xend = 73, 
                     yend = -.0000085), 
                 colour = "#cc0000",
                 size =8) +
    geom_segment(aes(x = 73, 
                     y = -.0000085, 
                     xend = 73+47, 
                     yend = -.0000085), 
                 colour = "#e57f00",
                 size=8) +
    geom_segment(aes(x = 73+47, 
                     y = -.0000085, 
                     xend = 73+47+39, 
                     yend = -.0000085), 
                 colour = "#cc4ccc",
                 size=8) +
    geom_segment(aes(x = 73+47+39, 
                     y = -.0000085, 
                     xend = 73+47+39+21, 
                     yend = -.0000085), 
                 colour = "#99cc19",
                 size=8) +
    geom_text(x=(73/2), y=-.0000072, label="f",color="black")+
    geom_text(x=(73+(47/2)), y=-.0000065, label="p",color="black")+
    geom_text(x=(73+47+(39/2)), y=-.000007, label="t",color="black")+
    geom_text(x=(73+47+39+(21/2)), y=-.0000068, label="o",color="black")
  
  plt
  
}
