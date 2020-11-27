%% main pipeline to output H's as spikes:
% have X already selected
%apply seqNMF
K = 7;
L = 20;%6000; %50 % length of timebins for each factor
lambda =0;%.005;%0.005;
lambdal1H = .48; % L1H just scales the HH
lambdaorthoW = 0;%.0002;%.0005; %how orthogonal the W's have to be
lOH = .1724; % lambda ortho 
lW1 = .03; % scales the lambda of W
shg; clf
display('Running seqNMF on simulated data (2 simulated sequences + noise)')
[W,H] = seqNMFVD(X,'K',K, 'L', L,'lambda', lambda,'lambdaL1H',lambdal1H,'lambdaL1W',lW1,'lambdaOrthoW',lambdaorthoW,'lambdaOrthoH',lOH);
%% check P value for current configuration for NMF:
values = [];
blah = linspace(0,1,30);
for i = 1:30
    for j = 1:30
    lOH = blah(i);
    lambdal1H = blah(j)
    [W,H] = seqNMFVD(X,'K',K, 'L', L,'lambda', lambda,'lambdaL1H',lambdal1H,'lambdaL1W',lW1,'lambdaOrthoW',lambdaorthoW,'lambdaOrthoH',lOH,'showplot',0);
    Hlocs = getHForNeuron(H,W);
    X_hat = helper.reconstruct(W,Hlocs);
    t = norm(vecnorm((X*X_hat')'),2)/sum(Hlocs,'all');
    values(i,j) = t;
    disp(i)
    disp(j)


    end
end

%% Look at factors
figure; SimpleWHPlot(W,H); title('SeqNMF reconstruction')
figure; SimpleWHPlot(W,H,X); title('SeqNMF factors, with raw data')

%% plot main H's
figure();
box off;
plot(1:size(H,2), bsxfun(@plus, H, (abs((0:(size(H,1)-1))-(size(H,1)-1))')));

%% get H's
Hlocs = getHForNeuron(H,W);
X_hat = helper.reconstruct(W,Hlocs);
res = X - X_hat;
figure();
plot(1:size(X_hat,2), bsxfun(@plus, X_hat, (abs((0:(size(X_hat,1)-1))-(size(res,1)-1))')));
figure();
plot(1:size(X,2), bsxfun(@plus, X, (abs((0:(size(X,1)-1))-(size(X,1)-1))')));
t = norm(vecnorm((X*X_hat')'),2)/sum(Hlocs,'all');
%% get h's
figure();
plot(Hlocs');
ylim([0 1.5]);
colSum = sum(Hlocs);
colSum(colSum > 0) = 1;

%% find distance


[ro co] = find(values == max(values,[],'all'));