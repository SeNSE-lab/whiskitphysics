function idx = expIndex(array)
%expIndex


array = double(array);
w_array = zeros(size(array));
s = 0;
for i = 1:length(array)
    w_array(i) = array(i)*exp(-abs(i-length(array)/2)/100);
    % weighted on center
    s = s + i*w_array(i);
end
idx = round(s/sum(w_array));
if sum(array) == 0
    idx = round(length(array)/2)-1;
end


end

