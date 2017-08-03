input_name = 'filtered_func_data';
Ftest_Prefix = 'Ftest_mycode_1';
Zstat_Prefix = 'Zstat_mycode_1';
 input_name = strcat(input_name,'.nii.gz');
 input = load_untouch_nii(input_name);
 inp_hdr = input.hdr;
 slice = double(input.img);
 
 f = size(slice);
%f = [64 64 35 624];
N_vols =f(4);
N = 1:N_vols;
N_slices = f(3);
Tr = 2;
Ta = Tr/(N_slices - 1);


fileID = fopen('model001_all.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
fclose(fileID);
B = A(1:3:end);
dur = A(2:3:end);
value = A(3:3:end);

B = ceil(B);
counter=1;
sig = zeros(f(4),1);
for i = 0:Tr:B(end)
    if i==B(counter)
        sig(i/Tr:(i+dur(counter))/Tr) = value(counter);
        counter = counter+1;
    end
end
HRF = DoubleGammaHRF([6.5 10.5 3],22,Tr);
convsig = conv(sig,HRF');
convsig = convsig(N);

%Create Design Matrix
design = zeros(N_vols,2);
design(:,1) = 2*ones(N_vols,1);
design(:,2) = convsig;
multMe1 = inv(design'*design);
multMe = multMe1*design';
Y_vals = zeros(N_vols,1);
beta_cap = zeros([f(1) f(2) f(3) 2]);
Y_cap = zeros(f);
F_test = zeros(f(1:3));
z_stat = zeros(f(1:3));
cont_vect = [0 1];
for i = 1:f(1)
    for j = 1:f(2)
        for k = 1:f(3)
            Y_vals(:,1) = slice(i,j,k,:);
            temp = multMe * Y_vals;
            beta_cap(i,j,k,:) = temp;
            temp2 = design*temp;
            Y_cap(i,j,k,:) = temp2;
           err = Y_vals - temp2;
            sig_sq = (err'*err)/(N_vols - 2);
            contrast = cont_vect*temp;
            cont_var_est = ((cont_vect*multMe1*cont_vect')*sig_sq)./length(cont_vect);
            if cont_var_est ==0
                F_test(i,j,k) =0;
            else
         %       F_test(i,j,k) = contrast'*sqrt(inv(cont_var_est ))*contrast;
          F_test(i,j,k) = contrast/sqrt(cont_var_est );
            end
        end
    end
end

op.img = F_test;
op.hdr = inp_hdr;
op.hdr.dime.dim(5)=1;

Ftest_Prefix= strcat(Ftest_Prefix,'.nii.gz');
save_nii(op,Ftest_Prefix);

%err = slice - Y_cap;
%sig_sq = (err'*err)/(N_vols - 2);
% betaNeed = beta_cap(:,:,:,2);
% meanbeta = mean(mean(mean(betaNeed)));
% sigma = var(betaNeed);
bins = F_test(:);
totsum = length(bins);
for i = 1:f(1)
    for j = 1:f(2)
        for k = 1:f(3)
            partivalue = F_test(i,j,k);
            bins_sm_than = find(bins<partivalue);
             %p_value = sum(bins(bins_sm_than))/totsum;
             p_value = length((bins_sm_than))/totsum;
           % oneminp = 1- pvalue;
if p_value ==0
    p_value =1e-300;
else if p_value ==1
        p_value = (1 - 1e-300);
    end
end

z_stat(i,j,k) = norminv(p_value);
            
        end
    end
end

ap.img = z_stat;
ap.hdr = inp_hdr;
ap.hdr.dime.dim(5)=1;
Zstat_Prefix= strcat(Zstat_Prefix,'.nii.gz');
save_nii(op,Zstat_Prefix);
%plot(convsig);
%plot(sig);
sum=0;
 for i =1:N_vols
     tempsl = slice(:,:,:,i);
    sum = sum + tempsl(:);
 end
 brainbins = find(sum~=0);
 Zstat_Prefix = 'Zstat_mycode_1';
 
 %It returns Coefficient of Determination, Parameter A & Parameter B after
 %linear regression.
 [COD,paramA,paramB] = scattCOD(Zstat_Prefix,brainbins);
 