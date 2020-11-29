% Compare spikesorted spiketimes to our spiketimes
myKsDir = "Kilosort_Output/"; % output files from OneDrive
load('Data/VedantFiles/vOutput.mat')

addpath(genpath("/Users/johnduva/Desktop/2020/Git/Project/spikes"))
% addpath(genpath("/Users/johnduva/Desktop/2020/Git/Project/npy-matlab"))
[~, ~, ~, spikeSites] = ksDriftmap(myKsDir); % this function lives in 'spikes'

spikeTimes = readNPY('spike_times.npy'); % requires npy-matlab 
all = [spikeTimes, spikeSites];

% Extract spiketimes in our interval: 113k->116.5k
ourInterval = [];
for spiketime = 1 : length(all)
    if all(spiketime,1)>=113000 && all(spiketime,1)<=116500
        ourInterval = [ourInterval; all(spiketime, :)];
    end
end

% channels is 70 to 110
ourChans = [];
for i = 1 : size(ourInterval, 1)
    if ourInterval(i,2)>=70 && ourInterval(i,2)<=110
        ourChans = [ ourChans; ourInterval(i,:) ];
    end
end

length(ourChans)

x = linspace(113000,116500, 3501)';
% check each of the 3500 frames to see if there is a spike there
kilosorted = zeros(length(x), 1);
for frame = 1 : length(x) %3500
    for spike = 1 : size(ourChans, 1) %37
        if x(frame) == ourChans(spike,1)
            kilosorted(frame,1) = 1;
        else
            continue
        end
    end
end

%% Plot figure
figure(1)
subplot(3,1,1)
plot(1:3501, kilosorted)
title("KiloSorted Spikes")

subplot(3,1,2)
plot(1:4000, [L_pred; zeros(500,1)] )
title("Clustering Algorithm Spikes")

subplot(3,1,3)
plot(1:3501, Voutput)
title("convNMF Spikes")



% figure(2)
% subplot(2,1,1)
% plot(1:3501, kilosorted)
% title("KiloSorted Spikes")
% 
% subplot(2,1,2)
% plot(1:4000, [L_pred; zeros(500,1)] )
% title("Parimal Spikes")

%% Plot all of the kilosort spikes that have a 'Voutput' spike and vise-versa
% Determine when 2 spikes are the "same" (occur within t frames of each other).
% Then look at % agreement and % disagreement.

load('Data/L_pred.mat', 'L_pred')
width = 5; % how many neighbors to consider on each side

% 'intersect' is all of the 'kilosorted' spikes that have a 'Voutput' spike
intersect = zeros(3501,1); % how many 1s in 'kilosorted' have a corresponding 1 in 'Voutput' at similar time
non_intersect = zeros(3501,1); % how many 1s in 'kilosorted' DONT have a corresponding 1 in 'Voutput' at similar time
for i = width+1 : length(kilosorted)-width
    % for each spike in kilosort
    if kilosorted(i) == 1
        % was there any spikes in 'Voutput' within t seconds of it?
        if any( Voutput(i-width:i+width) )
            intersect(i) = 1;
        else
            % count as a kilosort spike that DOES NOT have a 'Voutput' spike
            non_intersect(i) = 1;
        end
    end

end

% 'intersect4' is all of the 'kilosorted' spikes that have a Clustering spike
intersect4 = zeros(3501,1); % how many 1s in 'kilosorted' have a corresponding 1 in Clustering at similar time
non_intersect4 = zeros(3501,1); % how many 1s in 'kilosorted' DONT have a corresponding 1 in Clustering at similar time
for i = width+1 : length(kilosorted)-width
    % for each spike in kilosort
    if kilosorted(i) == 1
        % was there any spikes in Clustering within t seconds of it?
        if any( L_pred(i-width:i+width) )
            intersect4(i) = 1;
        else
            % count as a kilosort spike that DOES NOT have a Clustering spike
            non_intersect4(i) = 1;
        end
    end

end


% 'intersect2' is all of the 'Voutput' spikes that have a 'kilosorted' spike
intersect2 = zeros(3501,1); % how many 1s in 'Voutput' have a corresponding 1 in 'kilosorted' at similar time
non_intersect2 = zeros(3501,1); % how many 1s in 'Voutput' DONT have a corresponding 1 in 'kilosorted' at similar time
for i = width+1 : length(Voutput)-width
    % for each spike in kilosort
    if Voutput(i) == 1
        % was there any spikes in 'Voutput' within t seconds of it?
        if any( kilosorted(i-width:i+width) )
            intersect2(i) = 1;
        else
            % count as a kilosort spike that DOES NOT have a 'Voutput' spike
            non_intersect2(i) = 1;
        end
    end

end


intersect3 = zeros(3501,1); 
non_intersect3 = zeros(3501,1); 
for i = width+1 : length(L_pred)-width
    % for each spike in L_pred
    if L_pred(i) == 1
        % was there any spikes in 'Voutput' within t seconds of it?
        if any( kilosorted(i-width:i+width) )
            intersect3(i) = 1;
        else
            % count as a kilosort spike that DOES NOT have a 'Voutput' spike
            non_intersect3(i) = 1;
        end
    end
end




%% Plot kilsorted against clustering

% 'intersect' is all of the 'kilosorted' spikes that have a 'Voutput' spike
figure(1)
subplot(2,1,1)
hold on
plot(intersect4, 'blue')
plot(non_intersect4, 'red')
hold off
title('Kilosort')
lgd = legend("KiloSorted spikes with corresponding Clustering spike","KiloSorted spikes without Clustering spike" );
lgd.FontSize = 12;

% 'intersect3' is all of the 'L_pred' spikes that have a 'kilosorted' spike
subplot(2,1,2)
hold on
plot(intersect3, 'blue')
plot(non_intersect3, 'red')
hold off
title('Clustering Algorithm')
lgd2 = legend("Clustering spikes with corresponding KiloSorted spike","Clustering spikes without a KiloSorted spike" );
lgd2.FontSize = 12;

%% Plot kilsorted against convNMF
% 'intersect' is all of the 'kilosorted' spikes that have a 'Voutput' spike
figure(2)
subplot(2,1,1)
hold on
plot(intersect, 'blue')
plot(non_intersect, 'red')
hold off
title('Kilosort')
lgd = legend("KiloSorted spikes with corresponding convNMF spike","KiloSorted spikes without convNMF spike" );
lgd.FontSize = 12;

% 'intersect2' is all of the 'Voutput' spikes that have a 'kilosorted' spike
subplot(2,1,2)
hold on
plot(intersect2, 'blue')
plot(non_intersect2, 'red')
hold off
title('convNMF')
lgd2 = legend("ConvNMF spikes with corresponding KiloSorted spike","ConvNMF spikes without a KiloSorted spike" );
lgd2.FontSize = 12;


%Calulate agreement
% sum(intersect) / (sum(intersect)+sum(non_intersect))
% sum(intersect2) / (sum(intersect2)+sum(non_intersect2))

