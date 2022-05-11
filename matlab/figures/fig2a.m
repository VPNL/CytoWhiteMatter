% code to render the example connectome in figure 2a

 T = getfmridmriSessions_adults; 
 T = sortrows(T,11); %sort by age

fatDir = '/share/kalanit/biac2/kgs/projects/Kids_AcrossYears/dMRI/data/adults';
anatdir = '/share/kalanit/biac2/kgs/projects/Longitudinal/Anatomy';
runName = '96dir_run1';
foi= [11 13 19 27 21];
colorMap = [0 0.8 0.8; 1 0.5 1; 1 0 0; 1 0.6 0; 0.6 1 0.05]; 
fibername={'IFOF','ILF','AF','pAF','VOF'};
numfibers =[];
t1name = 'T1_QMR_1mm.nii.gz';
hemi = 'lh';
anatDir = '/share/kalanit/biac2/kgs/projects/Longitudinal/Anatomy';
roi = {'mOTS_word_cc3'};
 xform = [0.0006   -0.0002    1.0000  -91.0886;
   -0.0000   -1.0000   -0.0002   90.9280;
   -1.0000   -0.0000    0.0006  108.8446;
         0         0         0    1.0000];
     
for n =1:length(roi)
    fgName = strcat(hemi,'_',roi,...
        '_projed_gmwmi_r1.00_WholeBrainFGRadSe_classified_cleaner.mat');
    
    roiname = strcat(hemi,'_',roi);
     fatRenderFibersWholeConnectome_subplot(fatDir, T.sessid{20}, runName,...
                    fgName,foi,t1name,hemi,anatDir, ...
                    strcat(T.anatid{20},'/T1'),numfibers,1, 1, 1, colorMap,...
                    roiname,xform,0,1,'')
    imgDir = 'figures';
    outname = fullfile(imgDir,strcat(roi,'_1b.tif'));
    
    print(gcf,'-dtiff',outname,'-r600')
    close all
end

