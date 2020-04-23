function [retvec]=ScaleToUnitArea(vec);
% [retvec]=ScaleToUnitArea(vec);
% Scales vec to unit area
% Hartmann EDA Toolbox v1, Dec 2004

sumvec=sum(vec);
retvec=vec/sumvec;


