function [COD, paramA, paramB] = scattCOD(Zstatcode,brainbins)
Ftest_Prefix_FSL = 'Zstat_8hpf_80_FSL';
Ftest_Prefix_FSL = strcat(Ftest_Prefix_FSL,'.nii.gz');
ZstatFSL= load_untouch_nii(Ftest_Prefix_FSL);
ZstatFSL = ZstatFSL.img;
%Zstatcode = 'Ftest_8hpf_80';
Zstatcode = strcat(Zstatcode,'.nii.gz');
Zstatcode = load_untouch_nii(Zstatcode);
Zstatcode = Zstatcode.img;
Y = ZstatFSL(:);
X = Zstatcode(:);
Y = Y(brainbins);
X = X(brainbins);
nonzeroY = find(Y~=0);
nonzeroX = find(X~=0);
reqbins = intersect(nonzeroY, nonzeroX);
Y = Y(reqbins);
X = X(reqbins);

scatter(Y,X);
xlabel('Zstatcode');
ylabel('ZstatFSL');
%Xm(:,1) = ones(length(X),1);
%Xm(:,2) = X;
%params = Y\Xm;
meanY = mean(Y);
meanX = mean(X);
XminX = X - meanX;
paramA = (Y-meanY)'*(XminX)/(XminX'*XminX);
paramB = meanY - paramA * meanX;

Y_cap = paramA*X + paramB;
SSR = (Y_cap - meanY)'*(Y_cap - meanY);
SSTO = (Y-meanY)'*(Y-meanY);
COD = SSR/SSTO;

end