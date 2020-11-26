% Calculate the residual matrix and run Ljeung-Box Test on it
function decisions = ljeung_box(W, H,X)
    % subtract found templates and times from X:
    X_hat = helper.reconstruct(W,H);
    res = X - X_hat;

    channels = size(X_hat,1); % number of electrode channels
    decisions = zeros(channels,2);
    for i = 1 : channels
        [decisions(i,1), decisions(i,2)]  = lbqtest(res(i,:));
    end
end
