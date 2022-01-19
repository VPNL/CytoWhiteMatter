# dependencies 
library("RColorBrewer")
library("rlist")
library("ggcorrplot")

# make a color map for our correlation matrices
yellowrd <- rev(brewer.pal(n=9, name= "YlOrRd"))

# clip the color maps
yellowrd <- yellowrd[1:8]

blues <- brewer.pal(n=9,name="Blues")
blues <- blues[2:9]

# combine blue and red color maps
bluerdyellow <- c(blues,yellowrd)

myPalette <- colorRampPalette(bluerdyellow)

sc <- scale_fill_gradientn(colours = myPalette(100), limits=c(-1,1), name = "Correlation")

# exclude subjects that do not have both rois needed for the correlation 

func_exclude_subs_with_missing_rois = function(df,roinames,hemi){
  
  df <- 
    df %>% 
    filter(hem == hemi)

subs = levels(df$subject)
#roinames = c("mFus_Faces","mOTS_word","pFus_Faces")
holder=0
sublist = list()

for (i in 1:length(subs)){
  for (j in 1:length(roinames)){
    holder[j] = sum(with(df, subject==subs[i] & roi==roinames[j]))
  }
    if (min(holder) > 0){
      sublist = list.append(sublist,subs[i])
    }
}

df %>% 
  filter(subject %in% sublist)

}

# get the within-subject correlations 

func_corrrelations_across_subs = function(df,roinames,hemi,endpoint,age_group){
  
 df <-  
  df %>% 
    filter(group == age_group)
 
df_tmp <-func_exclude_subs_with_missing_rois(df,roinames,hemi)

  
subs = unique(df_tmp$subject)
corr_list = list()
sub_list = list()

for (i in 1:length(subs)){
  
  roi1<-
    df_tmp %>% 
    filter(subject == subs[i],
           roi==roinames[1],
           hem == hemi) 
  if (endpoint == 1){
    dist1 <- roi1$endpoint_proportion
  }
  else{
  dist1 <- roi1$percentage
  }
  
  roi2<-
    df_tmp %>% 
    filter(subject == subs[i],
           roi==roinames[2],
           hem == hemi) 
  if (endpoint == 1){
    dist2 <- roi2$endpoint_proportion
  }
  else{
      dist2 <- roi2$percentage
  }
  corr_list = list.append(corr_list,cor(dist1,dist2))
  sub_list = list.append(sub_list,subs[i])
}
x <- unlist(corr_list[!is.na(corr_list)])
y <- unlist(sub_list)
df.correlations = tibble(
  correlation = x,
  subject = y)
}

# fisher transformed correlations

func_corrrelations_across_subs_fisher = function(df,roinames,hemi,endpoint,age_group){
  
 df <-
  df %>%
    filter(group == age_group)
 
df_tmp <-func_exclude_subs_with_missing_rois(df,roinames,hemi)

  
subs = unique(df_tmp$subject)
corr_list = list()
sub_list = list()

for (i in 1:length(subs)){
  
  roi1<-
    df_tmp %>%
    filter(subject == subs[i],
           roi==roinames[1],
           hem == hemi)
  if (endpoint == 1){
    dist1 <- roi1$endpoint_proportion
  }
  else{
  dist1 <- roi1$percentage
  }
  
  roi2<-
    df_tmp %>%
    filter(subject == subs[i],
           roi==roinames[2],
           hem == hemi)
  if (endpoint == 1){
    dist2 <- roi2$endpoint_proportion
  }
  else{
      dist2 <- roi2$percentage
  }
  corr_list = list.append(corr_list,FisherZ(cor(dist1,dist2)))
  sub_list = list.append(sub_list,subs[i])
}
x <- unlist(corr_list[!is.na(corr_list)])
y <- unlist(sub_list)
df.correlations = tibble(
  correlation = x,
  subject = y)
}

# fisher transformed correlations

func_corrrelations_across_subs_fisher = function(df,roinames,hemi,endpoint,age_group){
  
 df <-
  df %>%
    filter(group == age_group)
 
df_tmp <-func_exclude_subs_with_missing_rois(df,roinames,hemi)

  
subs = unique(df_tmp$subject)
corr_list = list()
sub_list = list()

for (i in 1:length(subs)){
  
  roi1<-
    df_tmp %>%
    filter(subject == subs[i],
           roi==roinames[1],
           hem == hemi)
  if (endpoint == 1){
    dist1 <- roi1$endpoint_proportion
  }
  else{
  dist1 <- roi1$percentage
  }
  
  roi2<-
    df_tmp %>%
    filter(subject == subs[i],
           roi==roinames[2],
           hem == hemi)
  if (endpoint == 1){
    dist2 <- roi2$endpoint_proportion
  }
  else{
      dist2 <- roi2$percentage
  }
  corr_list = list.append(corr_list,FisherZ(cor(dist1,dist2)))
  sub_list = list.append(sub_list,subs[i])
}
x <- unlist(corr_list[!is.na(corr_list)])
y <- unlist(sub_list)
df.correlations = tibble(
  correlation = x,
  subject = y)
}

# make the correlation matrix 
func_correlation_matrix_across_subs = function(df,age_group,roilist,hemi,sc,endpoint){

  df <-
    df %>%
    filter(group == age_group)
  
mat <- matrix(,nrow=length(roilist),ncol=length(roilist))
rownames(mat) <- roilist
colnames(mat) <- roilist
for (r in 1:length(roilist)){
  for (j in 1:length(roilist)){
    tmp = func_corrrelations_across_subs(df,c(roilist[r],roilist[j]),hemi,endpoint,age_group)
    mat[r,j] = mean(tmp$correlation)
  }
}

plt <-
 mat %>%
  ggcorrplot(type="lower",
             legend.title="correlation",
             tl.cex = 12) +
  sc


if (age_group == "kid"){
  plt <-
  plt + ggtitle("Children") +
    theme(text = element_text(size =20),
         legend.title=element_text(size=8),
        legend.text=element_text(size=8),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank())
}
else if (age_group == "adult"){
  plt <-
  plt + ggtitle("Adults") +
    theme(text = element_text(size =20),
        legend.title=element_text(size=8),
        legend.text=element_text(size=8),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank())
}

plt +
  annotate("segment",
           x = .6, xend = 1.4, y = .3, yend = .3,
           size = 2, color = "magenta") +
  annotate("segment",
           x = 1.6, xend = 3.4, y = .3, yend = .3,
           size = 2, color = "cyan") +
  annotate("segment",
           x = .3, xend = .3, y = .6, yend = 2.4,
           size = 2, color = "magenta") +
  annotate("segment",
           x = .3, xend = .3, y = 2.6, yend = 3.4,
           size = 2, color = "cyan")
}
