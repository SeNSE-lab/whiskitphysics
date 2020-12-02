
function write_whisker_param()

pathout = '../../data/whisker_param_average_rat/';
param1 = compute_parameters('model',pathout,1);

pathout = '../../data/whisker_param_model_rat/';
param2 = compute_parameters('average',pathout,1);

legend([param1.plt,param2.plt],'model','average')

end

