function smooth(input_name,sl_correct,FWHM)
%input_name = 'bold_slcorrect';
%sl_correct = 'bold_smooth';
input_name = strcat(input_name,'.nii.gz');
input = load_untouch_nii(input_name);
inp_hdr = input.hdr;
inp_img = double(input.img);
%FWHM = 4; % Set it later.
res =4 ;  % Given resolution is 4mm3.
scale = 1; %To get the minimum points of filter to be 1.
f = size(inp_img);
N_vols =f(4);
N = 1:N_vols;
%N_slices = f(3);

fil_mat = zeros(f(1:3));
%db_size = 2*f(1:3);
x_cor = 128.5;
y_cor = -108.23;
z_cor = -73.05;

sig = FWHM/(sqrt(8*log(2)));
finI = (x_cor -res*(f(1)-1));
finJ = y_cor + res*(f(2)-1);
finK = z_cor + res*(f(3)-1);
i =128.5:(-res):finI;
i = i.^2;
for ap = 1:f(1)
    fil_mat(ap,:,:) = i(ap); 
end

j = y_cor:res:finJ;
j = j.^2;
for ap = 1:f(2)
    fil_mat(:,ap,:) = fil_mat(:,ap,:) + j(ap); 
end

k = z_cor:res:finK;
k = k.^2;
for ap = 1:f(3)
    fil_mat(:,:,ap) = fil_mat(:,:,ap) + k(ap); 
end

fil_mat = exp(-fil_mat*scale/(2*sig^2));
%fin_img = convn(inp_img,fil_mat,'same');
fftfilt = zeros(5*f(1:3));
 fft_filt = fftn(fil_mat,f(1:3));
 
 max_filt = max(max(max(abs(fft_filt))));
 fft_filt = fft_filt/max_filt;
 fftfilt(1:64,1:64,1:36) = fft_filt;
 fin_img = zeros(f);
 temp = zeros(f);
 fftimg = zeros(5*f(1:3));
 for vol =1:N_vols
     fft_img = fftn(inp_img(:,:,:,vol),f(1:3));
     fftimg(1:64,1:64,1:36) = fft_img;
     fin_img(:,:,:,vol) = abs(ifftn(fftimg.*fftfilt,f(1:3)));
    %fin_img(:,:,:,vol) = convn(inp_img(:,:,:,vol),fil_mat,'same');
 end
 for k =1:18
     temp(33:64,33:64,k+18,:) = fin_img(1:32,1:32,k,:);
      temp(1:32,1:32,k+18,:) = fin_img(33:64,33:64,k,:);
      temp(33:64,1:32,k+18,:) = fin_img(1:32,33:64,k,:);
      temp(1:32,33:64,k+18,:) = fin_img(33:64,1:32,k,:);
 end
 
 for k =19:36
     temp(33:64,33:64,k-18,:) = fin_img(1:32,1:32,k,:);
      temp(1:32,1:32,k-18,:) = fin_img(33:64,33:64,k,:);
      temp(33:64,1:32,k-18,:) = fin_img(1:32,33:64,k,:);
      temp(1:32,33:64,k-18,:) = fin_img(33:64,1:32,k,:);
 end
 %temp(:,:,1:18,:) = fin_img(:,:,19:36,:);
 %temp(:,:,19:36,:) = fin_img(:,:,1:18,:);
 
op.img = temp;
op.hdr = inp_hdr;
sl_correct= strcat(sl_correct,'.nii.gz');
save_nii(op,sl_correct);
end