% only take the channels we care about
templates2 = templates(:,:,70:110);
W2 = permute(W, [2 3 1]);
%         "W" = (channels x K x length)
% "templates" = (neurons  x  time  x channels)

% 1) which neurons correspond to each other, 
% 2) which channel to compare on, and 
% 3) what's the time alignment

% use EMD distance on spike trains to decide which neurons correspond, and compare those
% A = W2(:,:,neuronsA);
% B = templates2(:,:,neuronsB);
A = W2(:,:,1);
B = templates2(:,:,1);

dist = zeros(size(W2,1),size(templates2,1), 41);
for neuronsA = 1 : size(W2,1) %7
    for neuronsB = 1 : size(templates2,1) %414
        dist(neuronsA, neuronsB) = dtw(A(neuronsA,:), B(neuronsB,:));
%         dist(neuronsA, neuronsB) = emd(A(neuronsA,:), .5, B(neuronsB,:), .5);
    end
end

dist = zeros(size(W2,1),size(templates2,1), 41);
for neuronsA = 1 : size(W2,1) %7
    for neuronsB = 1 : size(templates2,1) %414
        dist(neuronsA, neuronsB) = dtw(A(1,:), B(114,:));
%         dist(neuronsA, neuronsB) = emd(A(neuronsA,:), .5, B(neuronsB,:), .5);
    end
end


% then you can pick the active channel in the templates (should just be one nonzero channel

% the last is figuring out how to appropriately compare those two vectors that may be of different lengths

% try to plot them against each other and see if it looks like a simple l2-norm restricted to the points in the smaller of the two vectors is reasonable


%% Look for the max correlation between any corresponding electrodes


%% another option is to measure the difference using the earth-mover's distance


%% might be a little harder to parse, but can also compute spike rates and compare via L2 norms etc


%% Compare our Ws with spikesorted templates
load('VedantFiles/W.mat')
templates = readNPY('Kilosort_Output/templates.npy'); 
spike_templates = readNPY('Kilosort_Output/spike_templates.npy'); 
spikeTimes = readNPY('spike_times.npy'); 
% templatesIDX = readNPY('Kilosort_Output/templates_ind.npy'); 
% spikeClusters = readNPY('Kilosort_Output/spike_clusters.npy');
 
% For each spike, get the spike template from the 41 relevant channels (so 41 spike templates):
act_pots = cell(155721,41); 
for channel = 70 : 110 % ...from the relevant channels.
    for i = 1 : 155721 % For each spike...
        spike = spike_templates(i)+1; % ...get the spike template...
        act_pots{i,channel-69} = templates(spike, :, channel); 
    end
end

% so we can now calculate an average template for each action potential (across columns)
avgs = zeros(155721,82);
for i = 1 : 155721
    for j = 1 : 41
        test(:,j) = cell2mat(act_pots(i,j))';
    end
    avgs(i,:) = mean(test,2)';
end

% keep only the average templates for the spikes between frames 113,000 and 116,500
keepers = avgs(5681:5816,:);

plot(1:82, bsxfun(@plus, keepers, (0:135)')');
