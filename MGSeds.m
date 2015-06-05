% Michael Hirsch
% This file reads downloaded .sri files to plot high-level Mars Global Surveyor
% radio occultation data from
% http://pds-geosciences.wustl.edu/missions/mgs/rsdata.html

clc, clear all, close all, fclose('all');
%% find .sri files in directory
path = 'data/';
d = dir([path,'*.sri']); 
fn = {d(:).name};

for i = 1:length(fn)
try
    fid = fopen([path,fn{i}(1:end-4),'.lbl']);
catch
    warning(['Label file for ',[path,fn{i}],' does not exist'])
    continue
end
lbl{i} = textscan(fid,'%s %s','Delimiter',' = ','MultipleDelimsAsOne',true);
fclose(fid);
%% check if image
ObjInd = find(strcmp(lbl{i}{1},'OBJECT'),1);
if isempty(ObjInd), warning(['File ',[path,fn{i}],' is not an image.'])
    continue
elseif ~strcmp(lbl{i}{2}(ObjInd),'IMAGE')
    warning(['File ',fn{i},' is not an image.'])
    continue
end
LinInd = find(strcmp(lbl{i}{1},'LINES'),1); NumLines(i) = str2double(lbl{i}{2}(LinInd));
LinInd = find(strcmp(lbl{i}{1},'LINE_SAMPLES'),1); NumSamp(i) = str2double(lbl{i}{2}(LinInd));
LinInd = find(strcmp(lbl{i}{1},'OFFSET'),1); Offset(i) = str2double(lbl{i}{2}(LinInd));
LinInd = find(strcmp(lbl{i}{1},'SCALING_FACTOR'),1); ScaleFact(i) = str2double(lbl{i}{2}{LinInd});

LinInd = find(strcmp(lbl{i}{1},'START_TIME'),1); StartDate{i} = lbl{i}{2}(LinInd);
%[startY(i), startM(i), startD(i),startH(i), startMN(i), startS(i)] = datevec([StartDate{i}{1}(1:10),' ',StartDate{i}{1}(12:19)],31);
startDateNum(i) = datenum([StartDate{i}{1}(1:10),' ',StartDate{i}{1}(12:19)],31);

LinInd = find(strcmp(lbl{i}{1},'STOP_TIME'),1); StopDate{i} = lbl{i}{2}(LinInd);
%[stopY(i), stopM(i), stopD(i),stopH(i), stopMN(i), stopS(i)] = datevec([StopDate{i}{1}(1:10),' ',StopDate{i}{1}(12:19)],31);
stopDateNum(i) = datenum([StopDate{i}{1}(1:10),' ',StopDate{i}{1}(12:19)],31);

%% get data
fidbin = fopen([path,fn{i}]);
imgData{i} = fliplr(fread(fidbin, [NumSamp(i),NumLines(i)], 'int16',0,'b').*ScaleFact(i) + Offset(i));
fclose(fidbin);
xBin = 4.88; %Hz, from .lbl description
xStart = 0; %Hz
xStop = 2500; %Hz
yBin = 0.2048/(60*60*24); % sec/(60*60*24), from .lbl description
end

%% display data
for i = 1:length(startDateNum)
    y = xStart:xBin:xStop; %Hz reversed
    x = startDateNum(i):yBin:stopDateNum(i);
    figure
   imagesc(x,y,imgData{i},[-205 -155]), axis xy
   title(['Start: ',datestr(startDateNum(i)),'. Stop: ',datestr(stopDateNum(i))])
   xlabel('Time of Day')
   ylabel('Baseband frequency [Hz]')
   datetick('x',13,'keeplimits')
   hc =  colorbar;
   ylabel(hc,'RX Power [dBW]')
end