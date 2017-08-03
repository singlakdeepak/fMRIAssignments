% slice_correct('bold_mcf_brain','bold_slcorrect',3);
% smooth('bold_slcorrect','bold_smooth',4);
% HPF('bold_smooth','bold_smooth_hpf',95);

N = zeros(2,1);

input_name = '/Users/myhome/Desktop/Academics/Semester6/fMRICourse/Assignments/Assign3';
for i=1:2
    st2 = '.feat/stats/zstat';
    inp_name = [input_name,st2,num2str(i)];
    inp_name = strcat(inp_name,'.nii.gz');
    input = load_untouch_nii(inp_name);
    inp_img = double(input.img);
    N(i) = sum(inp_img(:)>2.3);
end
%task001 Sp_Smooth - 4, HPF- 110 for max
%task002 Sp_Smooth - 4, HPF- 110 [67,111]  Sp_Smooth - 6, HPF - 80 [61 159] 
%task003 Sp_smooth - 4, HPF- 100 [120,152] Sp_smooth - 6, HPF- 80 [85,170] 
