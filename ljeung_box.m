% Calculate the residual matrix and run Ljeung-Box Test on it
function decisions = ljeung_box(W, H)
    % subtract found templates and times from X:
    X_hat = helper.reconstruct(W,H);
    res = X - X_hat;

    channels = size(X_hat,1); % number of electrode channels
    decisions = zeros(channels,1);
    for i = 1 : channels
        decisions(i) = lbqtest(res(i,:));
    end
end
