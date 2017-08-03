%clear all; close all; clc;

function  hrf = DoubleGammaHRF(params, timeDur,sampDur)
%timeDur is 2~3 s

tmax = max(params(2)*2,timeDur);
dt = sampDur;
T = 0:dt:(tmax-dt);
modelHRF = gampdf(T,params(1),1) - gampdf(T,params(2),1)/params(3);
modelHRF = modelHRF./sum(modelHRF(:));
hrf = modelHRF;
%plot(T,hrf);


end

%DoubleGammaHRF([6.5 5.5 3],20);%%%%%Don't use this.%%%%%%%%%
%DoubleGammaHRF([6.5 10.5 3],22);