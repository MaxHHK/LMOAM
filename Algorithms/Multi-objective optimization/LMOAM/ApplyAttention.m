function value = ApplyAttention(ValueIndividual,attention,maxVal,minVal)
% Funtion to apply attention on value individual to create new individuals
% ----------------------------------------------------------------------- 
%  Copyright (C) 2022 Haokai Hong
% ----------------------------------------------------------------------- 
% This file is derived from its original version containied in the PlatEMO 
% framework. 
% -----------------------------------------------------------------------
    value = ValueIndividual.*attention;
    if value < minVal
       value = minVal;
    elseif value > maxVal
       value = maxVal;
    end
end
