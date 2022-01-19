% code to render the example connectomes in figure 2a 

T = getfmridmriSessions_singleyr;
sessid = T.sessid{3}; anatid=T.anatid{3};

% define directories & inputs
outDir = ('/share/kalanit/biac2/kgs/projects/Kids_AcrossYears/dMRI/code/plotting/figures');
fatDir = '/share/kalanit/biac2/kgs/projects/Kids_AcrossYears/dMRI/data/kids';
runName = '96dir_run1';
colorMap = [0 0.8 0.8; 1 0.5 1; 1 0 0; 1 0.6 0; 0.6 1 0.05];  
xform = [0.0006   -0.0002    1.0000  -91.0886;
   -0.0000   -1.0000   -0.0002   90.9280;
   -1.0000   -0.0000    0.0006  108.8446;
         0         0         0    1.0000];
foi = [11 13 19 27 21];
t1name = 'T1_QMR_1mm.nii.gz';
hemi = 'lh';
h=1;
anatDir = '/share/kalanit/biac2/kgs/projects/Longitudinal/Anatomy';
rois = {'mFus_Faces_cc3', 'mOTS_word_cc3',...
    'pFus_Faces_cc3','pOTS_word_cc3'};


for n =1:length(rois)
    
    fgName = strcat(hemi,'_',rois{n},...
        '_disk_3mm_projed_gmwmi_r1.00_WholeBrainFGRadSe_classified_cleaner.mat');
    roiname = strcat(hemi,'_',rois{n},'_disk_3mm');
    
    fatRenderFibersWholeConnectome_subplot(fatDir, sessid, runName,...
                    fgName,foi,t1name,hemi,anatDir, ...
                    anatid,[],1, 1, 1, colorMap,...
                    roiname,xform,0,1,'C3')
    
    imgDir = 'figures';
    outname = fullfile(imgDir,strcat(rois{n},'_fdwmt.tif'));
    
    print(gcf,'-dtiff',outname,'-r600')
end

