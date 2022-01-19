function  fatRenderFibersWholeConnectome_subplot(fatDir, sessid, runName,...
    fgName,foi,t1name,hemi,anatdir, anatid,numfibers, r, c, n, colorMap,...
    roiname,xform,axial,classified,label)

%  fatRenderFibersWholeConnectome_subplot(fatDir, sessid, runName,...
%    fgName,foi,t1name,hemi,anatdir, anatid,numfibers, r, c, n, colorMap,...
%    roiname,xform,axial,classified,label)
%
% fatDir - directory where dMRI data is located 
% sessid - subfolder name for participant 
% runName - subfolder name for run 
% fgName - full name of fg including path and postfix
% foi - a vector to indicate fiber of interest
% t1name - name of t1 (e.g., 't1.nii.gz')
% hemi - 'rh' or 'lh'
% anatdir - directory where t1 is located 
% anatid - subfolder name for partipant in anatomy directory
% numfibers - number of fibers to render, default is [] (all fibers)
% r - number of rows for subplot 
% c - number of columns for subplot 
% n - subplot number 
% colormap - matrix of rbg values for rendering fibers 
% roiname - name of the functional roi to plot 
% xform - transformation between anatomy and diffusion data 
% axial - 1 or 0 (0 = coronal)
% label - string to label subplot in upper left. 
% 
% Adaped from 'fatRenderFibersWholeConnectome.m' written by MG
% Dependencies: AFQ (github.com/yeatmanlab/AFQ)

if isempty(colorMap)
    colorMap = [0 0.8 0.8; 1 0.5 1; 0.45 0 0.45; 1 0 0; 1 0.6 0; 0.6 1 0.05]; 
end

[~,fName] = fileparts(fgName);

if strcmp(hemi,'lh')
    cameraView = [-60,10];
    xplane =  [-15, 0, 0];
else strcmp(hemi,'rh')
    cameraView = [60,10];
    xplane =  [15,0,0];
end
zplane = [0, 0,-20];

if axial == 1
    cameraView = 'axial';
end 


% set criteria
maxDist = 4; maxLen = 4;numNodes = 100;M = 'mean';maxIter = 200;count = false;
        fprintf('Plot fiber %s-%s:%s\n',sessid,runName,fgName);
        
        cd(fullfile(fatDir,sessid,runName))
        subdir=dir('*trilin');
        runDir = fullfile(fatDir,sessid,runName,subdir.name);
        
        if classified == 1
            fibDir = fullfile(runDir, 'fibers','afq');
        else
            fibDir = fullfile(runDir,'fibers');
        end 
            
        
        if ~exist(fibDir, 'dir')
            mkdir(fibDir);
        end
        
        imgDir = fullfile(fibDir,'image');
        if ~exist(imgDir,'dir')
            mkdir(imgDir);
        end
        
        %% Load fg
        fgFile = fullfile(fibDir,fgName);
        if exist(fgFile,'file')
            load(fgFile);
            if exist('roifg')
            fg = roifg(foi);
            elseif exist('fg')
                fg=fg(foi)
            else
            fg = bothfg(foi); 
 
            end
            
            if classified == 1
                for i = 1:length(foi)
                    fg(i) = AFQ_removeFiberOutliers(fg(i),maxDist,maxLen,numNodes,M,count,maxIter);
                end
            end 
            
         
            % b0 = readFileNifti(fullfile(runDir,'bin','b0.nii.gz'));
            b0 = readFileNifti(fullfile(fatDir,sessid,runName,'t1',t1name));
            fibers = extractfield(fg, 'fibers');
            I =  find(~cellfun(@isempty,fibers));
            
            if isempty(I)==0
            AFQ_RenderFibers(fg(I(1)),...
                'color',colorMap(I(1),:),'camera',cameraView,...
                'alpha', 1,'subplot',[r c n],'numfibers',numfibers);
            
            for j = 2:length(I)
                AFQ_RenderFibers(fg(I(j)),...
                    'color',colorMap(I(j),:),'newfig',false, 'alpha',1,'numfibers',numfibers)
            end
            
            if exist('roiname','var')
                roi =(fullfile(anatdir,anatid,'ROIs',strcat(roiname,'.mat')));
                if exist(roi)
                    roi = dtiReadRoi(roi,xform);
                    AFQ_RenderRoi(roi, [0 0 0]); % Render the roi in black  
                end 
            end 

           if axial == 0
                AFQ_AddImageTo3dPlot(b0,zplane);
                AFQ_AddImageTo3dPlot(b0,xplane);
                axis square
            elseif axial == 1
                AFQ_AddImageTo3dPlot(b0,[90,0,0]);
                AFQ_AddImageTo3dPlot(b0,[0,0,10]);

            end
            clear fg roifg
            
            if exist('sub_num','var')
                text(.2,.85,label,'Color',...
                    'white','Units','normalized','FontSize',10)   
            end 
            
            axis off
       
            end
end
