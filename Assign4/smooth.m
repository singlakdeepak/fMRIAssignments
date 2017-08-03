function smooth(input_name,sl_correct,FWHM)
%input_name = 'bold_slcorrect';
%sl_correct = 'bold_smooth';
input_name = strcat(input_name,'.nii.gz');
input = load_untouch_nii(input_name);
inp_hdr = input.hdr;
inp_img = double(input.img);
%FWHM = 4; % Set it later.
res =3 ;  % Given resolution is 4mm3.
scale = 1; %To get the minimum points of filter to be 1.
f = size(inp_img);
N_vols =f(4);
fil_mat = zeros([7 7 5]);
%db_size = 2*f(1:3);

x_cor = 9;
y_cor = -9;
z_cor = -6.28;

sig = FWHM/(sqrt(8*log(2)));
finI = (x_cor -res*(6));
finJ = y_cor + res*(6);
finK = z_cor + 3.24*(4);
i =x_cor:(-res):finI;
i = i.^2;
for ap = 1:7
    fil_mat(ap,:,:) = i(ap);
    
end
% 
 j = y_cor:res:finJ;
j = j.^2;

for ap = 1:7
    fil_mat(:,ap,:) = fil_mat(:,ap,:) + j(ap); 
   
end

k = z_cor:res:finK;
k = k.^2;

for ap = 1:5
    fil_mat(:,:,ap) = fil_mat(:,:,ap) + k(ap);
    
end

fil_mat = exp(-fil_mat*scale/(2*sig^2));
max_filt = max(max(max(abs(fil_mat))));
fil_mat = fil_mat/max_filt;
% fftfilt = zeros(5*f(1:3));
%  fft_filt = fftn(fil_mat,f(1:3));
%  
%  max_filt = max(max(max(abs(fft_filt))));
%  fft_filt = fft_filt/max_filt;
%  fftfilt(1:f(1),1:f(2),1:f(3)) = fft_filt;
  
%  temp = zeros(f);

% save_nii(op,sl_correct);
size_fil = size(fil_mat);
flx = floor(size_fil(1)/2);
fly = floor(size_fil(2)/2);
flz = floor(size_fil(3)/2);

%tempimg = zeros([f(1)+6,f(2)+6,f(3)+4]);
fin_img = zeros([f(1)+6,f(2)+6,f(3)+4,N_vols]);

for vol = 1:N_vols
    tempimg = zeros([f(1)+6,f(2)+6,f(3)+4]);
    tempimg((flx+1):(f(1)+flx),(fly+1):(f(2)+fly),(flz+1):(f(3)+flz)) =  inp_img(:,:,:,vol);
    fin_img(:,:,:,vol) = convn(tempimg,fil_mat,'same');
end
op.img = fin_img((flx+1):(f(1)+flx),(fly+1):(f(2)+fly),(flz+1):(f(3)+flz),:);
 op.hdr = inp_hdr;
 sl_correct= strcat(sl_correct,'.nii.gz');
 save_nii(op,sl_correct);
end
