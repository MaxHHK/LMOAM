% ----------------------------------------------------------------------- 
% A demo to test LMOAM algorithms on the LSMOP benchmark suite.
% -----------------------------------------------------------------------
algorithms = {@LMOAM};
problems = {@LSMOP1, @LSMOP2, @LSMOP3, @LSMOP4, @LSMOP5, @LSMOP6, @LSMOP7, @LSMOP8, @LSMOP9};
N = 100;
M = 3;
maxFE = 100000;
Ds = {100, 500, 1000, 5000};

for d_index = 1:length(Ds)
    D = Ds{d_index};
    for a_index = 1:length(algorithms)
        algorithm = algorithms{a_index};
        for p_index = 1:length(problems)
            problem = problems{p_index};
            platemo('algorithm',{algorithm},'problem',{problem},'D',D,'M',M,'N',N,'maxFE',maxFE,'save',10);
        end
    end
end