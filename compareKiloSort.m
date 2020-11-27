% Compare spikesorted spiketimes to our spiketimes
myKsDir = "../Kilosort_Output/"; % output files from OneDrive
[~, ~, ~, spikeSites] = ksDriftmap(myKsDir); % this function lives in 'spikes'
spikeTimes = readNPY('spike_times.npy'); % requires npy-matlab 
all = [spikeTimes, spikeSites];

% our time interval is 113,000 to 116,500
all2 = [];
for spiketime = 1 : length(all)
    if all(spiketime,1)>=113000 && all(spiketime,1)<=116500
        all2 = [all2; all(spiketime, :)];
    end
end

% channels is 70 to 110
all3 = [];
for i = 1 : size(all2, 1)
    if all2(i,2)>=70 && all2(i,2)<=110
        all3 = [ all3; all2(i,:) ];
    end
end

x = linspace(113000,116500, 3501)';
% check each of the 3500 frames to see if there is a spike there
kilosorted = zeros(length(x), 1);
for frame = 1 : length(x) %3500
    for spike = 1 : size(all3, 1) %744
        if x(frame) == all3(spike,1)
            % if so, set to 1
            kilosorted(frame,1) = 1;
        else
            continue
        end
    end
end
both = [kilosorted, Voutput'];
%% Plot figure
load('vOutput.mat')

subplot(2,1,1)
plot(1:3501, kilosorted)
title("KiloSorted Spikes")

subplot(2,1,2)
plot(1:3501, Voutput)
title("Our Spikes")

%% Plot all of the kilosort spikes that have a 'Voutput' spike and vise-versa
% Determine when 2 spikes are the "same" (occur within t frames of each other) and look at % agreement and % disagreement

% 'intersect' is all of the 'kilosorted' spikes that have a 'Voutput' spike
width = 5; % how many neighbors to consider on each side
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

subplot(2,1,1)
hold on
plot(intersect, 'blue')
plot(non_intersect, 'red')
hold off
title('Kilosort')

subplot(2,1,2)
hold on
plot(intersect2, 'blue')
plot(non_intersect2, 'red')
hold off
title('Voutput')
