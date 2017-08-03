function slice_correct(input_name,sl_correct,slice_odr)
%input_name = 'bold_mcf_brain';
%sl_correct = 'bold_slcorrect';
input_name = strcat(input_name,'.nii.gz');
input = load_untouch_nii(input_name);
inp_hdr = input.hdr;
slice = double(input.img);

%slice_odr =3;
f = size(slice);
N_vols =f(4);
N = 1:N_vols;
N_slices = f(3);
Tr = 2.5;
Ta = Tr/(N_slices - 1);

Hfslices = floor(N_slices/2);

refslice = 18;
newSl = zeros(f);
vals = 0: Ta:Tr;

% slice_odr = 1 or 2 or 3 or 4;
% ====================================LINEAR INTERPOLATION=========================================
if slice_odr ==1    % [0,1,2,......,n-1]

for j = 1 : N_vols
		for i = 2: N_slices
		
            sliceI = slice(:,:,i,j);
			sliceIm1 = slice(:,:,i-1,j);
			sliceRef = (vals(refslice) - vals(i-1))*sliceI +(vals(i) - vals(refslice))*sliceIm1 ;
			sliceRef = abs(sliceRef/Ta);
			newSl(:,:,i,j) = sliceRef;
		
        end
		newSl(:,:,1,j) = slice(:,:,1,j);
end


elseif slice_odr ==2     % [n-1,n-2,.........,0]

	vals = Tr: (-Ta):0;
	for j = 1 : N_vols
		for i = 2: N_slices
			sliceI = slice(:,:,i,j);
			sliceIm1 = slice(:,:,i-1,j);
			sliceRef = (vals(refslice) - vals(i-1))*sliceI +(vals(i) - vals(refslice))*sliceIm1;
			sliceRef = abs(sliceRef/Ta);
			newSl(:,:,i,j) = sliceRef;
		end
		newSl(:,:,1,j) = slice(:,:,1,j);
	end

elseif slice_odr ==3     % Interleaved [0,2,4,....,1,3,.....]

	for i= 1:Hfslices
		vals(1,2*i-1) = (i-1)*Ta;
		vals(1,2*i) = Hfslices*Ta + (i-1)*Ta;
	end
	if mod(N_slices,2)~=0
		vals(1,end) = (Hfslices)*Ta;
    end
    for j = 1 : N_vols
        for i = 2: N_slices
			sliceI = slice(:,:,i,j);
			sliceIm1 = slice(:,:,i-1,j);
			sliceRef = (vals(refslice) - vals(i-1))*sliceI +(vals(i) - vals(refslice))*sliceIm1;
			sliceRef = abs(sliceRef/Ta);
			newSl(:,:,i,j) = sliceRef;
		end
		newSl(:,:,1,j) = slice(:,:,1,j);
    end
end
% ======================================================================================================
op.img = newSl;
op.hdr = inp_hdr;
sl_correct= strcat(sl_correct,'.nii.gz');
save_nii(op,sl_correct);
end
