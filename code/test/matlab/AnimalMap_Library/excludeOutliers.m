function [trimmedData,includedIndx]=excludeOutliers(data,numStds,method)
%The purpose of this function is to remove outliers for a dataset.  You can
%use one of several methods to specify what points you would like to be
%removed.
%
%   Inputs:
%       data: The full data set from which you want to exclude the
%       outliers.
%
%       numStds: The number of standard deviations beyond which you will
%       exclude data.  For the 'aboveMin' and 'belowMax' methods this input
%       is a number between 0 and 1 and not actually the number of standard
%       deviations. See variable method below.
%
%       method: There are five methods to choose from:
%           'fromMean': This method cuts any data that is above OR below
%           a number of standard deviations from the mean.
%
%           'aboveMean': this method cuts any data that is above a number
%           of standard deviations from the mean.
%
%           'belowMean': this method cuts any data that is below a number
%           of standard deviations from the mean.
%
%           'belowMax': This method cuts any data that is below a
%           percentage of the max value.  For example if I set numStds to
%           .7 then anything that is below 70% of the max input data will
%           be cut.
%
%           'aboveMin': This method cuts any data that is above a
%           percentage of the min value.  For example if I set numStds to
%           .7 then anything that is 70% above the minimum input 
%           data will be cut.
% 
%   Outputs:
%       trimmedData:
%           The data with the outliers removed.
%
%       includedIndx:
%           A logical matrix that is the same size as the input data. 0
%           means outlier, 1 means that the data point is included. This
%           matrix is often useful for excluding the outlier points from
%           additional marticies.
%

switch method
    case 'fromMean'
        stdData=std(data,1);
        meanData=mean(data);
        upper=meanData+numStds.*stdData;
        lower=meanData-numStds.*stdData;
        trimmedData=data(data<=upper & data>=lower,:);
        includedIndx=data<=upper & data>=lower;
        
    case 'aboveMean'
        stdData=std(data,1);
        meanData=mean(data);
        upper=meanData+numStds.*stdData;
        trimmedData=data(data<=upper,:);
        includedIndx=data<=upper;
        
    case 'belowMean'
        stdData=std(data,1);
        meanData=mean(data);
        lower=meanData-numStds.*stdData;
        trimmedData=data(data>=lower,:);
        includedIndx=data>=lower;
        
    case 'belowMax'
        maxData=max(data);
        lower=maxData-numStds*abs(maxData);
        trimmedData=data(data>=lower,:);
        includedIndx=data>lower;
        
    case 'aboveMin'
        minData=min(data);
        upper=minData+numStds.*minData;
        trimmedData=data(data<=upper,:);
        includedIndx=data<=upper;
    
    case 'fromMedian'
        iqrData = iqr(data);
        medianData = median(data);
        upper = prctile(data,75) + numStds*iqrData;
        lower = prctile(data,25) - numStds*iqrData;
        trimmedData=data(data<=upper & data>=lower,:);
        includedIndx=data<=upper & data>=lower;
    
    case 'NoElim'
        trimmedData=data;
        includedIndx=data;
        
end

end