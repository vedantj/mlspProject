fn = 'rec_bank0_t0.imec0.ap.bin'; 
 fid = fopen(fn, 'r'); 
 dat = fread(fid, [385 Inf], '*int16');
 fclose(fid);
  chanMap = readNPY('channel_map.npy'); 
dat = dat(chanMap+1,:); 
figure; imagesc(dat(:,:));

%% subset of that data:
%1-3 seconds
%channels %30:60
dat_sub = dat(30:60,30000:150000);

imagesc(dat_sub);
% figure();
% for i = 17: 17
%     hold on
%     %plot(dat_sub(i,:));
%     %x = conv(dat_sub(i,:),ones(1,10));
%     %plot(x);
% end

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

for i = 23:23
    %plot(dat_sub(i,:));
    %x = conv(dat_sub(i,:),ones(1,10));
    plot(y(i,:));
    
    %plot(y_ht(i,:));
end
%imagesc(y)
%% subset that is interesting
x = y(20:30,:);
 imagesc(x);
 
X = x;
 X =  X./(0.8*max(X(:)));
 
plot(1:size(X,2), bsxfun(@plus, X, (0:(size(X,1)-1))')');
 
%% do some pre processiong
t = (X<0);
X(t) = 0;
for i = 3:6
    %plot(dat_sub(i,:));
    %x = conv(dat_sub(i,:),ones(1,10));
    plot(x(i,:));
    hold on;
    
    %plot(y_ht(i,:));
end


t = (x<10);
x_ht = x;
x_ht(t)=0;
imagesc(x_ht)