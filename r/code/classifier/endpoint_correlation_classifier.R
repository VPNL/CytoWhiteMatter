endpoint_correlation_classifier = function(df,agegroup,classify_by){
# inputs: df - wide dataframe with columns for glasser roi, cyto, roi, subject, ect.
#         age group - 'kid' or 'adult'
#         classify_by - 'cyto', 'domain', or 'roi'
# 
# output: data frame with subject, classification accuracy for each split, 
# actual label, predicted label, age group
# 
# 

df <- 
  df %>% 
  filter(group == agegroup) 

 if (classify_by == 'cyto'){
   df <- 
     df %>% 
     mutate(grouping_var = cyto)
 } 
else if (classify_by == 'domain'){
  df <- 
     df %>% 
    mutate(grouping_var = domain)
} 
else if (classify_by == 'roi'){
  df <- 
     df %>% 
    mutate(grouping_var = roi)
} 

actual_labels = rep(NA, dim(df)[1])
predicted_labels = rep(NA, dim(df)[1])
accuracy = rep(NA,dim(df),1)


for (i in 1:dim(df)[1]){
test_data = df[i,]
test_subject = test_data$subject
test_profile <- 
  test_data %>% 
  pivot_longer(!c(cyto,domain,roi,subject,hem,group,fiber,grouping_var), 
               names_to = "glasser_roi", 
               values_to = "proportion") %>% 
  select(proportion)

# remove this subject from the training data 
train_data <-
 df %>%
 filter(subject != test_subject)
  
  # remove test data from the training set
  
  #train_data <-
  #df[-i,]

# get the mean connectivity profile for each label
avg_profiles <- 
train_data %>% 
  group_by(grouping_var) %>%
  summarise_at(vars(-c(cyto,domain,roi,subject,hem,group,fiber)), 
               funs(mean(., na.rm=TRUE))) %>% 
  pivot_longer(!grouping_var, 
               names_to = "glasser_roi", 
               values_to = "percentage") 

# take the correlation between the test connectivity profile 
# and the average for each label
unique_labels <- unique(avg_profiles$grouping_var)
correlations = rep(NA, length(unique_labels))

for (l in 1:length(unique_labels)){
  train_profile <-
    avg_profiles %>% 
    filter(grouping_var == unique_labels[l]) %>% 
    select(percentage)
  
  correlations[l] = cor(train_profile,test_profile)
}

# predict the label of the test profile based on the maximum correlation  
predicted_label = unique_labels[which.max(correlations)]
predicted_labels[i] = toString(predicted_label)

# record the actual label 
actual_label = test_data$grouping_var
actual_labels[i] = toString(actual_label)

# finally record the accuracy 
accuracy[i] = predicted_label == actual_label
}

df.classification = tibble(subject = df$subject, 
                           actual_label = actual_labels, 
                           predicted_label = predicted_labels,
                           classified_by = classify_by,
                           Group = agegroup,
                           Accuracy = accuracy)
}

endpoint_classifier_wrapper = function(df,hemi,roilist){
  # endpoint classifier wrapper
  #     input: df - wide data frame with endpoint connectivity profile
  #            hemi - 'lh' or 'rh'
  #            roilist - functional rois to use (e.g., mFus-faces)
  #      output: df.classification - df with classification accuracy
  #
  #
df <-
  df %>%
  filter(hem == hemi,
         roi %in% roilist)


kid_cyto <- endpoint_correlation_classifier(df,'kid','cyto')
kid_domain <- endpoint_correlation_classifier(df,'kid','domain')
kid_roi <- endpoint_correlation_classifier(df,'kid','roi')

adult_cyto <- endpoint_correlation_classifier(df,'adult','cyto')
adult_domain <- endpoint_correlation_classifier(df,'adult','domain')
adult_roi <- endpoint_correlation_classifier(df,'adult','roi')

df.classification <-
  rbind(kid_cyto,kid_domain,kid_roi,adult_cyto,adult_domain,adult_roi)

df.classification <-
  df.classification %>%
  mutate(classified_by =
           recode(classified_by,
                  cyto = "Cytoarchitecture",
                  domain = "Category",
                  roi = "ROI"),
         Group =
           recode(Group,
                  kid = "Children",
                  adult = "Adults"),
         Accuracy = Accuracy*100)

df.classification
}
