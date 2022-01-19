%% Code for saving the endpoint density maps in Figure 6.

[lh_rois,rh_rois,lh_lobe,rh_lobe] = glasserRois_noVTC_byLobe(0);

hex_colors = cell(length(lh_lobe),1);

for i =1:length(lh_rois)
        hex_colors{i} = '#808080';
end 

roilist = {'mFus_Faces_cc3','mOTS_word_cc3','pFus_Faces_cc3','pOTS_word_cc3'};
group = {'kid','adult'};
views ={'ventral','lateral'};

for g =1:2
    for r=1:length(roilist)
        for v =1:length(views)
        FS_Takescreenshots('fsaverage', 'lh',...
        ['lh_',roilist{r},'_wholebrain_scaled_concat_',group{g}],...
            lh_rois,hex_colors, views{v},...
            [roilist{r},'_',group{g},'_',views{v},'.png'])
        end 
    end
end

