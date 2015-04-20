function [C, sigma] = optimizeParams(X, y, XVal, yVal)

sample = [0.01; 0.03; 0.1; 0.3; 1; 3; 10; 30];
%sample = [0.01];
currentcost = 9999999999;

for i = 1:length(sample)
  for j = 1:length(sample)
    y1 = y2 = y3 = zeros(length(y),1);
    y1(y==1) = 1;
    y2(y==-1) = 1;
    y3(y==0) = 1;

    [modelu] = svmTrain(X, y1, sample(i), @(x1, x2) gaussianKernel(x1, x2, sample(j))); 
    [modeld] = svmTrain(X, y2, sample(i), @(x1, x2) gaussianKernel(x1, x2, sample(j))); 
    [modeln] = svmTrain(X, y3, sample(i), @(x1, x2) gaussianKernel(x1, x2, sample(j))); 

    [predictUp] = svmPredict(modelu, XVal);
    [predictDown] = svmPredict(modeld, XVal);
    [predictNeutral] = svmPredict(modeln, XVal);

    pp=[predictUp, predictDown, predictNeutral];
    [values,p]=max(pp,[],2);
    p(p==2) = -1;
    p(p==3) = 0;

    cost = mean(double(p ~= yVal));
    fprintf('cost for C = %f sigma = %f is %f...\n', sample(i), sample(j), cost);
    if(cost < currentcost)
      currentcost = cost;
      C = sample(i);
      sigma = sample(j);
    endif
  endfor
endfor





% =========================================================================

end
