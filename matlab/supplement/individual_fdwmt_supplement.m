% Makes a subplot with the individual fascicle connectivity profile for
% each participant organized by their age.

xform = [0.0006   -0.0002    1.0000  -91.0886;
    -0.0000   -1.0000   -0.0002   90.9280;
    -1.0000   -0.0000    0.0006  108.8446;
    0         0         0    1.0000];

rois = {'mFus_Faces_cc3','pFus_Faces_cc3','mOTS_word_cc3',...
    'pOTS_word_cc3','PPA_Placeshouses_cc3','OTS_Bodies_cc3'};


hemi = 'lh';
anatDir = '/share/kalanit/biac2/kgs/projects/Longitudinal/Anatomy';
t1name = 'T1_QMR_1mm.nii.gz';
runName = '96dir_run1';
foi= [11 13 19 27 21];
colorMap = [0 0.8 0.8; 1 0.5 1; 1 0 0; 1 0.6 0; 0.6 1 0.05];
fibername={'IFOF','ILF','AF','pAF','VOF'};
numfibers =[];
r=5;c=6;



for kid =1:2
    if kid == 1
        fatDir = '/share/kalanit/biac2/kgs/projects/Kids_AcrossYears/dMRI/data/kids';
        T = getfmridmriSessions_singleyr;
        T = sortrows(T,9); %sort by age
    else
        fatDir = '/share/kalanit/biac2/kgs/projects/Kids_AcrossYears/dMRI/data/adults';
        T = getfmridmriSessions_adults;
        T = sortrows(T,11); %sort by age
    end
    
    for rr=1:length(rois)
        for s=1:height(T)
            afqDir = fullfile(fatDir,T.sessid{s},'96dir_run1',...
                'dti96trilin','fibers','afq');
            fgName = strcat(hems{h},'_',rois{rr},...
                '_projed_gmwmi_r1.00_',...
                'WholeBrainFGRadSe_classified_cleaner','.mat');
            roiname = strcat(hems{h},'_',rois{rr});
            if exist(fullfile(afqDir,fgName))
                if kid == 1
                    sub_label = ['C',int2str(s)];
                else
                    sub_label = ['A',int2str(s)];
                end
                
                fatRenderFibersWholeConnectome_subplot(fatDir,...
                    T.sessid{s}, runName,fgName,foi,t1name,...
                    hemi,anatDir, strcat(T.anatid{s},'/T1'),...
                    numfibers,r, c, s, colorMap,...
                    roiname,xform,0,1,sub_label)
                
            end
        end
        imgDir = 'figures';
        if kid == 1
            outname = fullfile(imgDir,...
                strcat(hemi,'_',rois{rr},'_kids_subplot.tif'));
        else
            outname = fullfile(imgDir,...
                strcat(hemi,'_',rois{rr},'_adults_subplot.tif'));
        end
        print(gcf,'-dtiff',outname,'-r600')
        close all
    end
end
