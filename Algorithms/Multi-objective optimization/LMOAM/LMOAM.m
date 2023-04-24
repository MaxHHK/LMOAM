classdef LMOAM < ALGORITHM
% The algorithm for LMOAM, Balancing Exploration and Exploitation for Solv-
% ing Large-scale Multiobjective Optimization via Attention Mechanism
% ----------------------------------------------------------------------- 
% Reference:
% Hong, Haokai, et al. "Balancing exploration and exploitation for solving 
% large-scale multiobjective optimization via attention mechanism." 2022 
% IEEE Congress on Evolutionary Computation (CEC). IEEE, 2022.
% ----------------------------------------------------------------------- 
% Paramters:
% para_k        --- 5           --- Dimension of query
% para_g        --- 20          --- Number of queries
% para_e        --- 0.05 * EF   --- The function evaluation e for optimiza-
%                                   tion algorithm
% ----------------------------------------------------------------------- 
%  Copyright (C) 2022 Haokai Hong
% ----------------------------------------------------------------------- 
% This file is derived from its original version containied in the PlatEMO 
% framework. Part of the code refers to WOF.
% -----------------------------------------------------------------------
    methods
        function main(Algorithm,Problem)
            %% Set the default parameters
            para_k = 5;
            para_g = 20;
            para_e = 500;

            %% Generate random population
            Population = Problem.Initialization();
            Algorithm.NotTerminated(Population);
            
            Population = FillPopulation(Population, Problem);
            Population = OptimizeBySMPSO(Problem, Population, para_e, false);
            
            while Algorithm.NotTerminated(Population)

                valueList = SelectValue(Population, para_g); 
                newPopList   = [];
    
                for value_index = 1:size(valueList,2)
                    xValue             = valueList(value_index);
                    %  Query and Key
                    kMatrix            = ConstructKey(Population, para_k);
                    QuerySurrogate     = CreateQuerySurrogate(para_k, xValue, kMatrix, Problem, para_g);
                    QueryPopulation    = CreateInitialQueryPopulation(QuerySurrogate.N, para_k, QuerySurrogate);
                    % Optimize Query population
                    QueryPopulation    = OptimizeBySMPSO(QuerySurrogate, QueryPopulation, 0.1*para_e, true);
                    newPop             = AttentionToPopulation(QueryPopulation, Problem, Population, kMatrix, para_g);
                    newPopList         = [newPopList,newPop];  
                end
                Population          = EliminateDuplicates([Population,newPopList]);
                Population          = FillPopulation(Population, Problem);
    
                % Environmental Selection
                [Population,~,~]    = EnvironmentalSelection(Population,Problem.N);
                Population = OptimizeBySMPSO(Problem, Population, para_e, false);
            end
        end
    end
end

%% Create a surrogate to optimize Query Individuals
function QuerySurrogate = CreateQuerySurrogate(gamma, xValue, G, Global, populationSize)
    QuerySurrogate = {};
    QuerySurrogate.lower       = zeros(1,gamma);
    QuerySurrogate.upper       = ones(1,gamma).*2.0;
    [uniW,QuerySurrogate.N]    = UniformPoint(populationSize,Global.M);
    QuerySurrogate.uniW        = uniW;
    QuerySurrogate.xPrime      = xValue;
    QuerySurrogate.G           = G;
    QuerySurrogate.xPrimelower = Global.lower;
    QuerySurrogate.xPrimeupper = Global.upper;
    QuerySurrogate.isDummy     = true;
    QuerySurrogate.Global      = Global;
end

%% Process the population
function Population = EliminateDuplicates(input)
    % Eliminates duplicates in the population
    [~,ia,~] = unique(input.objs,'rows');
    Population = input(ia);
end

function Population = FillPopulation(input, Global)
    % Fills the population with mutations in case its smaller than Global.N
    Population = input;
    theCurrentPopulationSize = size(input,2);
    if theCurrentPopulationSize < Global.N
        amountToFill    = Global.N-theCurrentPopulationSize;
        FrontNo         = NDSort(input.objs,inf);
        CrowdDis        = CrowdingDistance(input.objs,FrontNo);
        MatingPool      = TournamentSelection(2,amountToFill+1,FrontNo,-CrowdDis);
        Offspring       = OperatorGA(input(MatingPool));
        Population      = [Population,Offspring(1:amountToFill)];
    end
end

%% Initialize query populatioin
function queryPopulation = CreateInitialQueryPopulation(N, para_k, QuerySurrogate)
    decs = rand(N,para_k).*2.0;
    queryPopulation = [];
    for i = 1:N
        solution = QueryIndividual(decs(i,:),QuerySurrogate);
        queryPopulation = [queryPopulation, solution];
    end
end

%% Apply attention to value to generate population
function Populatioin = AttentionToPopulation(QueryPopulation, QuerySurrogate, Population, kMatrix, q)
    attentionIndividualList = SelectValue(QueryPopulation, q);
    calc = size(attentionIndividualList,2)*size(Population,2);

    PopDec1 = ones(calc,QuerySurrogate.D);
    count = 1;
    for wi = 1:size(attentionIndividualList,2)
        attentionIndividual = attentionIndividualList(wi);
        attention = attentionIndividual.dec;
        for i = 1:size(Population,2)
            individualVars = Population(i).dec;
            x = ApplyAttention(individualVars,attention(kMatrix),QuerySurrogate.upper,QuerySurrogate.lower);
            PopDec1(count,:) = x;
            count = count + 1;
        end
    end
    Populatioin = SOLUTION(PopDec1);
end

%% Select value individual
function valueIndList = SelectValue(input, amount)
    inputSize = size(input,2);
    inFrontNo    = NDSort(input.objs,inf);
    valueIndList = [];
    i = 1;
    if inputSize < amount
        valueIndList = input;
    else
        while size(valueIndList,2) < amount 
            left = amount - size(valueIndList,2);
            theFront = inFrontNo == i;
            newPop = input(theFront);
            FrontNo    = NDSort(newPop.objs,inf);
            CrowdDis   = CrowdingDistance(newPop.objs,FrontNo);
            [~,I] = sort(CrowdDis,'descend');
            until=min(left,size(newPop,2));
            valueIndList = [valueIndList,newPop(I(1:until))];
            i=i+1;
        end
    end
end