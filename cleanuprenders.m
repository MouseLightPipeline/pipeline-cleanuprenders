function cleanuprenders(inputfolder,outputfolder)
% deletes render files, keeps top 2 levels and 1 full tree branch for allen
% registration and ktx support
% inputfolder = '/nrs/mouselight/SAMPLES/2014-06-24-rerender'
% outputfolder = '/nrs/mouselight/SAMPLES/2014-06-24-rerender-2level'
% cleanuprenders(inputfolder,outputfolder)
if nargin==1
    sample=inputfolder;
    cleanuprenders(sprintf('/nrs/mouselight/SAMPLES/%s',sample),sprintf('/nrs/mouselight/SAMPLES/%s-nearline',sample))
    return
end
opt.inputfolder = inputfolder;%'/nrs/mouselight/SAMPLES/2017-02-22';
opt.outputfolder = outputfolder;%'/nrs/mouselight/SAMPLES/2017-02-22-2level';
mkdir(opt.outputfolder)
%%
% copy top level files
myfiles = dir(opt.inputfolder)
copythese = find(~[myfiles.isdir]);
for ii=copythese
    myfile = myfiles(ii).name;
    tr=strsplit(myfile,'.');
%     fullfile(tr(1:end-1))
    %[aa,bb,cc] = fileparts(myfile);
%     cc
    if myfile(1) == '.' | strcmp(tr{end},'db')
        continue
    end
    
    unix(sprintf('cp "%s" %s',fullfile(opt.inputfolder,myfile),[opt.outputfolder,'/']));
end
%%
if exist(fullfile(inputfolder,'transform.txt'),'file')
    optTransform = configparser(fullfile(inputfolder,'transform.txt'));
    lvl = optTransform.nl;
else
    lvl = 7;
end

opt.seqtemp2 = fullfile(opt.inputfolder,'fulldepth.txt');
unix(sprintf('rm %s',opt.seqtemp2))
args.ext = 'tif';
args.level = lvl;
args.fid = fopen(opt.seqtemp2,'w');
recdiratdepth(opt.inputfolder,args,1)
fid=fopen(opt.seqtemp2,'r');
inputfiles = textscan(fid,'%s');
inputfiles = inputfiles{1};
fclose(fid);

%%
C = strsplit(inputfiles{1},'/');
outfile = fullfile(opt.outputfolder,C{end-lvl+1:end})
mkdir(fileparts(outfile))
unix(sprintf('cp %s %s',inputfiles{1},outfile))
%% copy ktx
unix(sprintf('mv %s %s',fullfile(opt.inputfolder,'ktx'),fullfile(opt.outputfolder,'ktx')))
%%
% %%
% for ii=1:lvl
%     infold = inputfiles{}
% end
% 
% %%
% opt.seqtemp = fullfile(opt.inputfolder,'deletedfilelist.txt');
% unix(sprintf('rm %s',opt.seqtemp))
% args.ext = 'tif';
% for lvl = 1:2
%     args.level = lvl;
%     if exist(opt.seqtemp, 'file') == 2
%         args.fid = fopen(opt.seqtemp,'a');
%     else
%         args.fid = fopen(opt.seqtemp,'w');
%     end
%     recdir(opt.inputfolder,args)
% end
%%
% opt.seqtemp2 = fullfile(opt.inputfolder,'fulldepth.txt');
% unix(sprintf('rm %s',opt.seqtemp2))
% args.ext = 'tif';

% %%
% fid=fopen(opt.seqtemp,'r');
% inputfiles = textscan(fid,'%s');
% inputfiles = inputfiles{1};
% fclose(fid);
% 
% fid=fopen(opt.seqtemp2,'r');
% inputfiles2 = textscan(fid,'%s');
% inputfiles{end+1} = inputfiles2{1}{1};
% inputfiles{end+1} = strrep(inputfiles{end},'default.0','default.1');
% fclose(fid);
% %%
% parfor ii=1:size(inputfiles,1)
%     outfile = strrep(inputfiles{ii},opt.inputfolder,opt.outputfolder);
%     [aa,bb,cc] = fileparts(outfile);
%     mkdir(aa)
%     unix(sprintf('cp %s %s',inputfiles{ii},strrep(inputfiles{ii},opt.inputfolder,opt.outputfolder)))
% end
% %%
% %% copy ktx
% unix(sprintf('mv %s %s',fullfile(opt.inputfolder,'ktx'),fullfile(opt.outputfolder,'ktx')))

