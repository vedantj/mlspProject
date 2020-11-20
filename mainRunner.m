%% run this after getting X;
% visualize everything

%X = y(42:60,74000:85000)
X = y(70:110,50000+33000:86500);
%X = y(70:110,13500:16500); % shows pretty good sequences
X_ht =  X./(0.8*max(X(:)));    % normalizes
 
X_ht = movmedian(X_ht',10)'; %smoothing
plot(1:size(X_ht,2), bsxfun(@plus, X_ht, (0:(size(X_ht,1)-1))')');

%% export to seqNMF try to make signal all positive:

t = (X_ht<0);
X_ht(t) = abs(X_ht(t));
X = X_ht;

%% apply seqnmf:
K = 4;
L = 25;%6000; %50 % length of timebins for each factor
lambda =0.0000001;%0.005;
shg; clf
display('Running seqNMF on simulated data (2 simulated sequences + noise)')
[W,H] = seqNMF(X,'K',K, 'L', L,'lambda', lambda,'lambdaL1H',.0005);
%% compare to original X
figure();
plot(1:size(X,2), bsxfun(@plus, X, (0:(size(X,1)-1))')');
