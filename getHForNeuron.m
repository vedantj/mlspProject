function Hlocs = getHForNeuron(H,W)
%This function returns an array giving the H for that neuron
%Array of 0's and 1's. Is N X K with N = number of neurons, K = length of time, 1's mean
%spike, 0's mean no spike
Hlocs = zeros(size(H));
for i = 1:size(H,1)
    currentH = H(i,:);
    thres = prctile(currentH,99);
    [pks loc] = findpeaks(currentH,'MinPeakProminence',thres);
    Hlocs(i,loc) = 1;%pks
    
end
%% plot the H's
figure();
plot(1:size(Hlocs,2), bsxfun(@plus, Hlocs, (abs((0:(size(Hlocs,1)-1))-(size(Hlocs,1)-1))')));
title('Time Series of Spikes for different Neurons');
ylabel('Neuron');
xlabel('Time');

end

