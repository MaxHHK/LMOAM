classdef QueryIndividual < handle
% QueryIndividual - The class of a query individual used for LMOAM
% ----------------------------------------------------------------------- 
%  Copyright (C) 2022 Haokai Hong
% ----------------------------------------------------------------------- 
% This file is derived from its original version containied in the PlatEMO 
% framework. 
% -----------------------------------------------------------------------
    
    properties(SetAccess = private)
        dec;        % Decision variables of the individual
        obj;        % Objective values of the individual
        con;        % Constraint values of the individual
        add;        % Additional properties of the individual
        ind;        % the actual individual to extract later
    end
    methods
        %% Constructor
        function obj = QueryIndividual(variables, Surrogate, addValues)
            
            if nargin > 0
                xValueVars = Surrogate.xPrime.dec;
                xValueSize = size(xValueVars,2);
                obj = QueryIndividual;
                
                % Set the infeasible decision variables to boundary values
                variables  = max(min(variables,Surrogate.upper),Surrogate.lower);

                x = ApplyAttention(xValueVars,variables(Surrogate.G),Surrogate.xPrimeupper,Surrogate.xPrimelower);
                
                obj.dec = variables;
                obj.ind = SOLUTION(x);
                obj.obj = obj.ind.obj;
                obj.con = obj.ind.con;
             
                if nargin > 2
                    CallStack = dbstack();
                    Field     = CallStack(2).name;
                    obj.add.(Field) = addValues;
                end
            end
            
        end
        %% Get the matrix of decision variables of the population
        function value = decs(obj)
            value = cat(1,obj.dec);
        end
        %% Get the matrix of objective values of the population
        function value = objs(obj)
            value = cat(1,obj.obj);
        end
        %% Get the matrix of constraint values of the population
        function value = cons(obj)
            value = cat(1,obj.con);
        end
        %% Get the matrix of additional property of the population
        function value = adds(obj,addValue)
            CallStack = dbstack();
            Field     = CallStack(2).name;
            value     = zeros(length(obj),size(addValue,2));
            for i = 1 : length(obj)
                if ~isfield(obj(i).add,Field)
                    obj(i).add.(Field) = addValue(i,:);
                end
                value(i,:) = obj(i).add.(Field);
            end
        end
    end
end