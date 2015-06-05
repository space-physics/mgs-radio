% Michael Hirsch
% This file reads downloaded .sri files to plot high-level Mars Global Surveyor
% radio occultation data from
% http://pds-geosciences.wustl.edu/missions/mgs/rsdata.html
%
% Note, the .lbl format is not nice for parsing. Matlab textscan() can manage
% it, but Octave 3.8/4.0 cannot. Sorry.

clc, clear all, close all, fclose('all');
%% find .sri files in directory
path = 'data/';
d = dir([path,'*.sri']); 
fn = {d(:).name};

startDateNum=[]; %in case nothing found
for i = 1:length(fn)
try
    fid = fopen([path,fn{i}(1:end-4),'.lbl']);
catch
    warning(['Label file for ',[path,fn{i}],' does not exist'])
    continue
end
lbl = textscan(fid,'%s %s','Delimiter',' = ','MultipleDelimsAsOne',true);
fclose(fid);
%% check if image
ObjInd = find(strcmp(lbl{1},'OBJECT'),1);
if isempty(ObjInd), warning(['File ',[path,fn{i}],' is not an image.'])
    continue
elseif ~strcmp(lbl{2}(ObjInd),'IMAGE')
    warning(['File ',fn{i},' is not an image.'])
    continue
end
LinInd = find(strcmp(lbl{1},'LINES'),1); NumLines = str2double(lbl{2}(LinInd));
LinInd = find(strcmp(lbl{1},'LINE_SAMPLES'),1); NumSamp = str2double(lbl{2}(LinInd));
LinInd = find(strcmp(lbl{1},'OFFSET'),1); Offset = str2double(lbl{2}(LinInd));
LinInd = find(strcmp(lbl{1},'SCALING_FACTOR'),1); ScaleFact = str2double(lbl{2}{LinInd});

LinInd = find(strcmp(lbl{1},'START_TIME'),1); StartDate = lbl{2}(LinInd);
%[startY(i), startM(i), startD(i),startH(i), startMN(i), startS(i)] = datevec([StartDate{i}{1}(1:10),' ',StartDate{i}{1}(12:19)],31);
startDateNum(i) = datenum([StartDate{1}(1:10),' ',StartDate{1}(12:19)],31);

LinInd = find(strcmp(lbl{1},'STOP_TIME'),1); StopDate = lbl{2}(LinInd);
%[stopY(i), stopM(i), stopD(i),stopH(i), stopMN(i), stopS(i)] = datevec([StopDate{i}{1}(1:10),' ',StopDate{i}{1}(12:19)],31);
stopDateNum(i) = datenum([StopDate{1}(1:10),' ',StopDate{1}(12:19)],31);

%% get data
fidbin = fopen([path,fn{i}]);
imgData{i} = fliplr(fread(fidbin, [NumSamp,NumLines], 'int16',0,'b').*ScaleFact + Offset);
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