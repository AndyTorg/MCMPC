function [dydx, x] = smoothDiff (x, y,fr)


slope = gradient (y,x);
slope = [-max(abs(slope)).*ones(50,1)' slope'];
slope = fastsmooth(slope,fr,3,1); %(slope(end:-1:1)
dydx = slope(51:end)';   %(end-0:-1:1)';

% here = 1


% dydx = slope;