function Gbest = OptimizeBySMPSO(Surrogate, inputPopulation, evaluations, isDummy)
% This function performs the optimisation by using the SMPSO
% methodology. 
% ----------------------------------------------------------------------- 
% This file is derived from its original version containied in the PlatEMO 
% framework. 
% -----------------------------------------------------------------------

    %% Generate random population
    Population       = inputPopulation;
    Pbest            = Population;
    [Gbest,CrowdDis] = UpdateGbest(Population,Surrogate.N);
    
    maximum = currentEvaluations(Surrogate, isDummy) + evaluations;

    %% Optimization
    while currentEvaluations(Surrogate, isDummy) < maximum
        Population       = SMPSO(Surrogate, [Population,Pbest,Gbest(TournamentSelection(2,Surrogate.N,-CrowdDis))], isDummy);
        [Gbest,CrowdDis] = UpdateGbest([Gbest,Population],Surrogate.N);
        Pbest            = UpdatePbest(Pbest,Population);
    end

end

function e = currentEvaluations(Surrogate, isDummy)
    if isDummy == true  
        e = Surrogate.Global.FE;
    else
        e = Surrogate.FE;
    end
end

function Pbest = UpdatePbest(Pbest,Population)
    replace        = ~all(Population.objs>=Pbest.objs,2);
    Pbest(replace) = Population(replace);
end

function [Gbest,CrowdDis] = UpdateGbest(Gbest,N)
    Gbest    = Gbest(NDSort(Gbest.objs,1)==1);
    CrowdDis = CrowdingDistance(Gbest.objs);
    [~,rank] = sort(CrowdDis,'descend');
    Gbest    = Gbest(rank(1:min(N,length(Gbest))));
    CrowdDis = CrowdDis(rank(1:min(N,length(Gbest))));
end