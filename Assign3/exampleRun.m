function exampleRun(input,FWHM) 

slice_correct(input,'filtered_func_data_slcorrect_task001',3);
 smooth('filtered_func_data_slcorrect_task001','filtered_func_data_smooth_task001',FWHM);
 for i =1:5
     file = sprintf('%s_%d','filtered_func_data_smooth_hpf_task001',i*10 +70);
 HPF('filtered_func_data_smooth_task001',file,i*10 +70);
 end
end


% input = filtered_func_data_task001;
% exampleRun('filtered_func_data_task001', 4);