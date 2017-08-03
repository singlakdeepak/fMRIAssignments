function exampleRun(input) 

%slice_correct(input,'filtered_func_data_slcorrect_task001',1);
for j=4:8
 
    smtfile=sprintf('%s_%d','filtered_func_data_smooth',j);
    smooth(input,smtfile,j);
 for i =1:2:5
     hpfile = strcat(smtfile,'hpf'); 
     file = sprintf('%s_%d',hpfile,i*10 +70);
 HPF(smtfile,file,i*10 +70);
 end
end
end


% input = filtered_func_data_task001;
%exampleRun('filtered_func_data_slcorrect');
