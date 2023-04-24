function [attentionIndexList] = ConstructKey(Population, groups)
% Construct Key Matrix
% ----------------------------------------------------------------------- 
%  Copyright (C) 2022 Haokai Hong
% ----------------------------------------------------------------------- 
% This file is derived from its original version containied in the PlatEMO 
% framework. 
% -----------------------------------------------------------------------
    decs = Population.decs();
    var_decs = var(decs);
    attention = (mapminmax(var_decs) + 1) / 2;
    numberOfGroups = groups - 1;
    attention = attention * numberOfGroups;
    attentionIndexList = round(attention) + 1;
end

