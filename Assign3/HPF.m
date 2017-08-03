function HPF(input_name,hpf_correct,cut_t)
%input_name = 'bold_smooth';
%hpf_correct = 'bold_smooth_hpf';
input_name = strcat(input_name,'.nii.gz');
input = load_untouch_nii(input_name);
inp_hdr = input.hdr;
inp_img = double(input.img);
f = size(inp_img);
N_vols =f(4);

tempser = zeros(1,N_vols);

%plot(abc);
%cut_t = 20;
Tr = 2.5;
val = (N_vols+1)*Tr/cut_t;
bin_cut = floor(val);
temp = zeros(f);
for i = 1:f(1)
    for j = 1:f(2)
        for k = 1:f(3)
 tempser = fft(inp_img(i,j,k,:));
 tempser(1,1:bin_cut) =0;
 temp(i,j,k,:) = abs(ifft(tempser));
        end
    end
end

op.img = temp;
op.hdr = inp_hdr;
hpf_correct= strcat(hpf_correct,'.nii.gz');
save_nii(op,hpf_correct);
end