get_roi_counts <- function(df.wide,agegroup,hemi){
  # get_roi_counts:
  #  counts how many functional ROIs (mFus-faces, mOTS-words, pFus-faces, pOTS-words) 
  #  are defined for a given age group (children/adult) and hemisphere (lh/rh) and 
  #  outputs a text file to label plots with this number in the format "n=X".
  # 
  # inputs: 
  #  df.wide - wide data frame with the connectivity profile for each fROI
  #  agegroup - "kid" or "adult"
  #  hemi - hemisphere "lh" or "rh" 
  #
  # output: 
  #   dat_text - text file to label each subplot with the number of observations
  # 

  roi_counts <-
    df.wide %>% 
    filter(group ==agegroup,
           hem == hemi,
           roi %in% c("mFus-faces","mOTS-words","pFus-faces","pOTS-words")) %>% 
    group_by(roi) %>% 
    count()
  
  labels= character(4)
  for(i in 1:4){
    labels[i] = paste0("n=",roi_counts$n[i])
  }
  
  dat_text <- data.frame(
    label = c(labels),
    roi = c("mFus-faces","mOTS-words","pFus-faces","pOTS-words"),
    x     = c(1.25, 1.25, 1.25,1.25),
    y     = c(90, 90, 90,90)
  )
  dat_text
}

fascicle_plot <- function(df,agegroup,hemi,dat_text){
  # fascicle_plot:
  #  plots the connecitivity profile (e.g., the percentage of fibers connecting to five 
  #  fascicles: IFOF, ILF, AF, pAF, VOF) for each for four functional ROIs 
  #  (mFus-faces, mOTS-words, pFus-faces, pOTS-words) for a given age group 
  #  (children/adult) and hemisphere (lh/rh) 
  # 
  # inputs: 
  #  df - data frame with the connectivity profile for each fROI
  #  agegroup - "kid" or "adult"
  #  hemi - hemisphere "lh" or "rh" 
  #  dat_text - text file with the number of observations for each panel 
  #  (from 'get_roi_counts')
  #
  # output: 
  #  plot of connectivity profiles
  # 
  
  p <-  df %>%
    filter(
      group == agegroup,
      hem == hemi,
      roi %in% c("mFus-faces", "mOTS-words", "pFus-faces", "pOTS-words")
    ) %>%
    ggplot(aes(x = tract,
               y = percentage,
               fill = tract)) +
    stat_summary(fun = "mean",
                 geom = "bar") +
    stat_summary(
      fun.data = "mean_se",
      geom = "linerange",
      size = 1,
      color = "black"
    ) +
    geom_point(
      alpha = 0.3,
      position = position_jitter(height = 0, width = 0.1),
      color = "gray",
      size = 2
    ) +
    labs(x = element_blank(), y = ("Percentage")) +
    theme(
      axis.title.x = element_blank(),
      #axis.text.x=element_blank(),
      axis.text.x = element_text(size = 8),
      axis.ticks.x = element_blank(),
      legend.position = "none",
      aspect.ratio = 1,
      text = element_text(size = 20),
      element_line(size = 1)
    ) +
    
    scale_fill_manual(values = c("#007f7f",
                                 "#cc4ccc",
                                 "#cc0000",
                                 "#e57f00",
                                 "#99cc19")) +
    ylim(0, 100) +
    facet_wrap( ~ roi, nrow = 2, ncol = 2)
  
  
  p +
    geom_text(data = dat_text,
              aes(x = x, y = y, label = label),
              inherit.aes = FALSE)
}