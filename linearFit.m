function [X Y beta0 beta1 deltab0 deltab1 outlinersIndex R2] =  linearFit(X, Y, tn2)

Sxx = 0;
Syy = 0;
Sxy = 0;
n = numel(X);

%% Etimation of the coef
for ii = 1:n
    Sxx = Sxx + power(X(ii) - mean(X),2);
    Syy = Syy + power(Y(ii) - mean(Y),2);
    Sxy = Sxy + (X(ii) - mean(X))*(Y(ii) - mean(Y));
end
beta1 = Sxy/Sxx;
beta0 = mean(Y) - beta1*mean(X); 

%% Estimation of the error on the coef

sigma2 = (Syy - beta1*Sxy)/(n-2);
vb0 = sigma2*(1/n + (mean(X)^2)/Sxx);
vb1 = sigma2*(1/Sxx);

deltab0 = tn2*sqrt(vb0);
deltab1 = tn2*sqrt(vb1);


%% Removal of outliners

count = 1;
outlinersIndex = [];
for ii = 1:n
    e(ii) = Y(ii) - (beta0 + beta1*X(ii)); %residual
    d(ii) = norm(e(ii)/sqrt(sigma2)); %standardise residual
    if d(ii) > tn2
        outlinersIndex(count) = ii;
        count = count + 1;
    end
end

if ~isempty(outlinersIndex)
        X(outlinersIndex) = [];
        Y(outlinersIndex) = [];
end
n = numel(X);

%% Lack of Test Fitting

SSE = 0;

for ii =1:n
    SSE = SSE + power(Y(ii) - (beta1*X(ii) + beta0),2);
end

%% Re-Estimation of the Coef
beta1 = Sxy/Sxx;
beta0 = mean(Y) - beta1*mean(X); 

%% Re-Estimation of the error on the coef

sigma2 = (Syy - beta1*Sxy)/(n-2);
vb0 = sigma2*(1/n + (mean(X)^2)/Sxx);
vb1 = sigma2*(1/Sxx);

deltab0 = tn2*sqrt(vb0);
deltab1 = tn2*sqrt(vb1);

R2 = 1- SSE./Syy;
    



