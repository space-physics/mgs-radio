%% USE readmgs.py INSTEAD
% Michael Hirsch
% This file reads downloaded .sri files to plot high-level Mars Global Surveyor
% radio occultation data from
%
% http://pds-geosciences.wustl.edu/missions/mgs/rsdata.html
%
% Cumulative file index:
% http://pds-geosciences.wustl.edu/mgs/mgs-m-rss-5-sdp-v1/mors_1038/index/cumindex.tab
%
% Example data from:
% http://pds-geosciences.wustl.edu/mgs/mgs-m-rss-5-sdp-v1/mors_1014/

function MGSeds(varargin)
%% find .sri files in directory

p = inputParser;
addOptional(p,'path','data/')
parse(p,varargin{:})
U = p.Results;
ddir=U.path;

d = dir([ddir,'*.sri']); 
fn = {d(:).name};
%% read  .lbl file
for i = 1:length(fn)
try
    fid = fopen([ddir,fn{i}(1:end-4),'.lbl'],'r');
catch
    warning(['Label file for ',[ddir,fn{i}],' does not exist'])
    continue
end
lbl = textscan(fid,'%s %s','Delimiter','        = ','MultipleDelimsAsOne',true);
fclose(fid);

%% check if image 

ObjInd = find(strcmp(lbl{1},'OBJECT'),1);
if isempty(ObjInd), warning(['File ',[ddir,fn{i}],' is not an image.'])
    continue
elseif ~strcmp(lbl{2}(ObjInd),'IMAGE')
    warning(['File ',fn{i},' is not an image.'])
    continue
end
%% get data parameters from parsed data
LinInd = find(strcmp(lbl{1},'LINES'),1); NumLines = str2double(lbl{2}(LinInd));
LinInd = find(strcmp(lbl{1},'LINE_SAMPLES'),1); NumSamp = str2double(lbl{2}(LinInd));
LinInd = find(strcmp(lbl{1},'OFFSET'),1); Offset = str2double(lbl{2}(LinInd));
LinInd = find(strcmp(lbl{1},'SCALING_FACTOR'),1); ScaleFact = str2double(lbl{2}{LinInd});

LinInd = find(strcmp(lbl{1},'START_TIME'),1); StartDate = lbl{2}(LinInd);
%[startY(i), startM(i), startD(i),startH(i), startMN(i), startS(i)] = datevec([StartDate{i}{1}(1:10),' ',StartDate{i}{1}(12:19)],31);
t0 = datenum([StartDate{1}(1:10),' ',StartDate{1}(12:19)],31);

LinInd = find(strcmp(lbl{1},'STOP_TIME'),1); StopDate = lbl{2}(LinInd);
%[stopY(i), stopM(i), stopD(i),stopH(i), stopMN(i), stopS(i)] = datevec([StopDate{i}{1}(1:10),' ',StopDate{i}{1}(12:19)],31);
tEnd = datenum([StopDate{1}(1:10),' ',StopDate{1}(12:19)],31);

%% get data
fidbin = fopen([ddir,fn{i}]);
imgData = fliplr(fread(fidbin, [NumSamp,NumLines], 'int16',0,'b').*ScaleFact + Offset);
fclose(fidbin);
xBin = 4.88; %Hz, from .lbl description
xStart = 0; %Hz
xStop = 2500; %Hz
%% get time of data from .srt
% technique: first column is time in seconds from the previous earth midnight, we know samples are supposed
% to be 0.2048 sec. spacing from .lbl file description
% http://pds-geosciences.wustl.edu/mgs/mgs-m-rss-5-sdp-v1/mors_1014/document/srx.txt
%texp = csvread([ddir,fn{i}(1:end-4),'.srt']); %nope

t = gettime([ddir,fn{i}(1:end-4),'.srt'],t0);

assert(tEnd>=t(end))

plottrans(t,xStart,xBin,xStop,imgData,fn{i})
end %for

end %function 

function t = gettime(srtfn,t0)
fid = fopen(srtfn,'r');
fgetl(fid); %throw away header
texp = textscan(fid,'%f %*d %*d %*f %*f',...
                'Delimiter',{',',' '},'MultipleDelimsAsOne',true);
fclose(fid);

epoch = getepoch(t0);
t = epoch+texp{1}/86400; %datenum

end % function

function epoch = getepoch(t)

[y,m,d] = datevec(t);
epoch = datenum([y,m,d]);

end %function

function plottrans(t,xStart,xBin,xStop,imgData,fn)
%% display data

freq = transpose(xStart:xBin:xStop); %Hz reversed

  
figure
h=pcolor(transpose(t),freq(1:end-1),imgData);
set(h,'EdgeColor','none')

axis xy
title([fn,'  ',datestr(t(1),'yyyy-mm-dd')])
xlabel('Time of Day')
ylabel('Baseband frequency [Hz]')
datetick('x',13,'keeplimits')

hc =  colorbar;
ylabel(hc,'RX Power [dBW]')

end %function