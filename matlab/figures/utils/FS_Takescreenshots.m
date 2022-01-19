function FS_Takescreenshots(FSSubj, hemi, mapName, labelList, colorList, view, titleName)
% Description: this script opens freeview and takes a screenshot of a given
% subject and map/label, view

%% Inputs: for example
% (1) name of fs directory, FSSubj = 'AW05avg_2345_affine';
% (2) hemi = 'lh' or 'rh'
% (2) mapName =
% 'lh_Word_vs_all_except_Number_151105_01_1_alignedTempl_projmax', can also
% be '' if no map should be loaded
% and (3) labelList, for example labelList={'FG1', FG2}
% (4) colorList = list of colors for labels (hex)
% (5) view='ventral', 'lateral','medial', or 'posterior'
% (6) optional:  title for image/screenshot
%
% 
% Written by MN 2021 
% Adapted by EK 2021

%% view settings
% Set here the view settings, this is for ventral view
if strcmp(view, 'ventral')
    settingsView = ' -cam dolly 1.2 azimuth 180 elevation 270 roll 270';
elseif strcmp(view, 'lateral')
%    settingsView = ' -cam dolly 1.2 azimuth 10 elevation -21 roll 0';
    settingsView = ' -cam dolly 1.2 azimuth 0 elevation 0 roll 0';
elseif strcmp(view,'posterior')
    settingsView = ' -cam dolly 1.2 azimuth 65 elevation 0 roll 0';
elseif strcmp(view,'medial')
    settingsView = ' -cam dolly 1.2 azimuth 180 elevation 0 roll 0';
else 
    sprintf('THis view has not yet been defined. Choose ventral or lateral')
end

% set here if label should be displayed as outline (1) or not (0)
labelOutlineFlag = ':label_outline=1';

screenshotCmd = ' -ss screenshot';


%% directory
FSDir = '/share/kalanit/biac2/kgs/3Danat/FreesurferSegmentations/';
% move into subj directory
cd([FSDir FSSubj])

freeviewCMD = sprintf('freeview -f surf/%s.inflated:curvature_method=binary', hemi);

%% load map and label if applicable on surface in freeview, set 3d view  and rotate to  view, take screenshot
if ~isempty(mapName)
    % Setting to threshold overlay at 3 and don't show negative vals
    %overlayThreshold = ':overlay_threshold=0.00000610344,.00006:overlay_color=heat' ;
    overlayThreshold = ':overlay_threshold=0.00000610344,.0003:overlay_color=colorwheel' ;
    freeviewCMD = [freeviewCMD sprintf(':overlay=%s.mgh%s',  mapName, overlayThreshold)] ;
end
if ~isempty(labelList)
    labelCMD ='';
    for l=1:length(labelList)
        labelName=labelList{l};
         colorname=colorList{l};
         %colorname = 'white';
      
         labelCMD = [labelCMD sprintf(':label=label/glasserAtlas/%s%s:label_color=%s', labelName,labelOutlineFlag, colorname)];
    end

    freeviewCMD = [freeviewCMD labelCMD];
end
freeviewCMD = [freeviewCMD sprintf(' --viewport 3D %s %s', settingsView, screenshotCmd)];
unix(freeviewCMD)

%% finally rename screenshot

if isempty(titleName)
    % make compatibile for old matlab version
    idx= strfind(mapName, '_');
    timepoint=mapName(idx(end-3)+1:idx(end-1)-1);
    contrast=mapName(idx(1)+1:idx(end-4)-1);

    imageName = sprintf('%s_%s_%s_%sView.png', hemi, contrast, timepoint, view);
else
    imageName=titleName; 
end
movefile('screenshot.png', imageName);

end
