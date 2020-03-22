% Matlab script for the segmentation of  individual T1w images into brain regions defined by 
% SPM12 Neuromephometric atlas. the resulting atlas are per individual and can be used for computng summary statistics such as regional grey nmatter volumes,...
% Author Ferath Kherif -  first version 12-05.2017
% THe script was tested with and valided with clinical Hospital data data from  Bordeaux and Lille. 
% Input information Please
% modify if needed. 
% You can adapt the following lines
% You can use the folloing line to slect the T1w images for each patient, the alternaltive is to create a list with the images filenames in a cell (cellststr)
imgs=spm_select([1 Inf],'image','select structural data');
imgs=cellstr(imgs);
cwd=pwd;
csvfilename='Neuromorphometrics_volumes.csv';
spmdir=spm_str_manip(which('spm'),'h');
xA = spm_atlas('load','Neuromorphometrics');
%save data in csv format
csvout=fopen(fullfile(cwd,csvfilename),'w');
fprintf(csvout,'SubjectId,');
for reg=1:size(xA.labels,2)
    fprintf(csvout,'%s,',strrep(xA.labels(reg).name,' ','_'));
end
for i=1:length(imgs)
cd(spm_str_manip(imgs{i},'h'))
matlabbatch{1}.spm.spatial.preproc.channel.vols = imgs(i);
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {fullfile(spmdir,'tpm','TPM.nii,1')}; 
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {fullfile(spmdir,'tpm','TPM.nii,2')};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {fullfile(spmdir,'tpm','TPM.nii,3')};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {fullfile(spmdir,'tpm','TPM.nii,4')};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {fullfile(spmdir,'tpm','TPM.nii,5')};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {fullfile(spmdir,'tpm','TPM.nii,6')};
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write = [1 1];
matlabbatch{2}.spm.util.defs.comp{1}.def(1) = cfg_dep('Segment: Inverse Deformations', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','invdef', '()',{':'}));
matlabbatch{2}.spm.util.defs.out{1}.pull.fnames = {fullfile(spmdir,'tpm','labels_Neuromorphometrics.nii')};
matlabbatch{2}.spm.util.defs.out{1}.pull.savedir.savepwd = 1;
matlabbatch{2}.spm.util.defs.out{1}.pull.prefix = [spm_str_manip(imgs{i},'tr') '_'];
matlabbatch{2}.spm.util.defs.out{1}.pull.interp = 0;
matlabbatch{2}.spm.util.defs.out{1}.pull.mask = 1;
matlabbatch{2}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
%spm_jobman('run',matlabbatch)
po=matlabbatch{2}.spm.util.defs.out{1}.pull.fnames{1};
vl=spm_vol(fullfile(spm_str_manip(imgs{i},'h'),[matlabbatch{2}.spm.util.defs.out{1}.pull.prefix spm_str_manip(po,'t')]));
vc1=spm_vol(fullfile(spm_str_manip(imgs{i},'h'),['c1' spm_str_manip(imgs{i},'t')]));
xA = spm_atlas('load','Neuromorphometrics');
[xAs] = atlas_project(vc1.fname,vl.fname,xA,'sum');
fprintf(csvout,'\n%s,',spm_str_manip(imgs{i},'tr'));
for reg=1:size(xA.labels,2)
fprintf(csvout,'%6.8f,',xAs.labels(reg).value);
end
end
fclose all



