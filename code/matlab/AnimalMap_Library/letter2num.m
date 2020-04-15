function number=letter2num(letter)
% The purpose of this function is to take in a letter and output its place
% in the alphabet
%
%   Inputs: 
%       letter: a character representing the number you want
%
%   Outputs:
%       number: a number corresponding the the place of the letter in the
%       alphabet.
%
        alphabet='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        nums=1:56;
        number=nums(repmat(letter,1,52)==alphabet);
        
        if number>26
           number=number-26; 
        end
        
end