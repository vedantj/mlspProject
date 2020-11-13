fn = 'rec_bank0_t0.imec0.ap.bin'; 
 fid = fopen(fn, 'r'); 
 dat = fread(fid, [385 Inf], '*int16');
 fclose(fid);
  chanMap = readNPY('channel_map.npy'); 
dat = dat(chanMap+1,:); 
figure; imagesc(dat(:,:));

%% subset of that data:

dat_sub = dat(1:30,30000:120000);

imagesc(dat_sub);
figure();
for i = 17: 17
    hold on
    %plot(dat_sub(i,:));
    %x = conv(dat_sub(i,:),ones(1,10));
    %plot(x);
end

%% apply bandpass filter
FS2 = 30000;

bpFilt2 = designfilt('bandpassfir','FilterOrder',150, ...
         'CutoffFrequency1',300,'CutoffFrequency2',3000, ...
         'SampleRate',FS2); 
     
D = mean(grpdelay(bpFilt2));
N = size(dat_sub,1);
%fvtool(bpFilt2);


y = double(dat_sub);

y = filter(bpFilt2,[y (zeros(N,D))]'); % Append D zeros to the input data
y = y(D+1:end,:)';
%y_ht = movmedian(y,100,2);
% fs = 30000;
% dat_subman = double(dat_sub');
% filtered = (bandpass(dat_subman,[300 3000],30000))';

imagesc(y); 
%% look at specific channels

for i = 9:9
    hold on
    %plot(dat_sub(i,:));
    %x = conv(dat_sub(i,:),ones(1,10));
    plot(y(i,:));
    %plot(y_ht(i,:));
end
%imagesc(y)