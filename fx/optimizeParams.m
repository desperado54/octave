function [C, sigma] = optimizeParams(X, y, XVal, yVal, C, sigma)

%sample = [0.01; 0.03; 0.1; 0.3; 1; 3; 10; 30];
sample = [0.1];
currentcost = 9999999999;

for i = 1:length(sample)
  %C = sample(i);
  for j = 1:length(sample)
    %sigma = sample(j);
    y1 = y2 = y3 = zeros(length(y),1);
    y1(y==1) = 1;
    y2(y==-1) = 1;
    y3(y==0) = 1;

    [modelu] = svmTrain(X, y1, C, @(x1, x2) gaussianKernel(x1, x2, sigma)); 
    [modeld] = svmTrain(X, y2, C, @(x1, x2) gaussianKernel(x1, x2, sigma)); 
    [modeln] = svmTrain(X, y3, C, @(x1, x2) gaussianKernel(x1, x2, sigma)); 

    [predictUp] = svmPredict(modelu, XVal);
    [predictDown] = svmPredict(modeld, XVal);
    [predictNeutral] = svmPredict(modeln, XVal);

    pp=[predictUp, predictDown, predictNeutral];
    [values,p]=max(pp,[],2);
    p(p==2) = -1;
    p(p==3) = 0;

    cost = mean(double(p ~= yVal));
    fprintf('cost for C = %f sigma = %f is %f...\n', C, sigma, cost);
    if(cost < currentcost)
      currentcost = cost;
      C = sample(i);
      sigma = sample(j);
    endif
  endfor
endfor





% =========================================================================

end
