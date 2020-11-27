%% Readme: basics
% import Y to matlab before running this:
% visualize everything

%X = y(42:60,74000:85000)
X = y(70:110,50000+33000:86500);
%X = y(70:110,13500:16500); % shows pretty good sequences
X_ht =  X./(0.8*max(X(:)));    % normalizes
 
%X_ht = movmedian(X_ht',100)';%smoothing USE WDNOISE
 %X_ht = wdenoise(X_ht',2,'DenoisingMethod','BlockJS','Wavelet','sym4')';
%%
figure();
plot(1:size(X_ht,2), bsxfun(@plus, X_ht, (0:(size(X_ht,1)-1))')');

%% export to seqNMF try to make signal all positive:

t = (X_ht<0);
X_ht(t) = abs(X_ht(t));
X = X_ht;

%% apply seqnmf:
K = 10;
L = 20;%6000; %50 % length of timebins for each factor
lambda =0;%.005;%0.005;
lambdal1H = .8; % L1H just scales the HH
lambdaorthoW = 0;%.0002;%.0005; %how orthogonal the W's have to be
lOH = .08; % lambda ortho 
lW1 = .01; % scales the lambda of W
shg; clf
display('Running seqNMF on simulated data (2 simulated sequences + noise)')
[W,H] = seqNMFVD(X,'K',K, 'L', L,'lambda', lambda,'lambdaL1H',lambdal1H,'lambdaL1W',lW1,'lambdaOrthoW',lambdaorthoW,'lambdaOrthoH',lOH);


%% Look at factors
figure; SimpleWHPlot(W,H); title('SeqNMF reconstruction')
figure; SimpleWHPlot(W,H,X); title('SeqNMF factors, with raw data')

%% look at raw output:
figure();
plot(1:size(X_ht,2), bsxfun(@plus, X_ht, (abs((0:(size(X_ht)-1))-(size(X_ht,1)-1))')));
title('Our Data');
xlabel('Time');
ylabel('Electrodes');
%% look at the wave form of specific W's:
w1 = squeeze(W(:,6,:));
figure();
plot(1:size(w1,2), bsxfun(@plus, w1, (0:(size(w1,1)-1))')');
%% Procedure for choosing K
tic
Ws = {};
Hs = {};
numfits = 7; %number of fits to compare
for k = 1:10
    display(sprintf('running seqNMF with K = %i',k))
    for ii = 1:numfits
        [Ws{ii,k},Hs{ii,k}] = seqNMF(X,'K',k, 'L', L,'lambda', 0,'showplot',0); 
        % note that max iter set low (30iter) for speed in demo (not recommended in practice)
    end
    inds = nchoosek(1:numfits,2);
    for i = 1:size(inds,1) % consider using parfor for larger numfits
            Diss(i,k) = helper.DISSX(Hs{inds(i,1),k},Ws{inds(i,1),k},Hs{inds(i,2),k},Ws{inds(i,2),k});
    end
    
end
%% Plot Diss and choose K with the minimum average diss.
figure,
plot(1:10,Diss,'ko'), hold on
h1 = plot(1:10,median(Diss,1),'k-','linewidth',2);
h2 = plot([3,3],[0,0.5],'r--');
legend([h1 h2], {'median Diss','true K'})
xlabel('K')
ylabel('Diss')



%% compare to original X
figure();
plot(1:size(X,2), bsxfun(@plus, X, (0:(size(X,1)-1))')');
