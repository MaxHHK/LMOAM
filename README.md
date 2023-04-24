# LMOAM
 Code for Balancing Exploration and Exploitation for Solving Large-scale Multiobjective Optimization via Attention Mechanism (LMOAM))

## Paper
[Balancing Exploration and Exploitation for Solving Large-scale Multiobjective Optimization via Attention Mechanism](https://ieeexplore.ieee.org/document/9870430/)

### Abstract
Large-scale multiobjective optimization problems (LSMOPs) refer to optimization problems with multiple con-flicting optimization objectives and hundreds or even thousands of decision variables. A key point in solving LSMOPs is how to balance exploration and exploitation so that the algorithm can search in a huge decision space efficiently. Large-scale multi-objective evolutionary algorithms consider the balance between exploration and exploitation from the individual's perspective. However, these algorithms ignore the significance of tackling this issue from the perspective of decision variables, which makes the algorithm lack the ability to search from different dimensions and limits the performance of the algorithm. In this paper, we propose a large-scale multiobjective optimization algorithm based on the attention mechanism, called (LMOAM). The attention mechanism will assign a unique weight to each decision variable, and LMOAM will use this weight to strike a balance between exploration and exploitation from the decision variable level. Nine different sets of LSMOP benchmarks are conducted to verify the algorithm proposed in this paper, and the experimental results validate the effectiveness of our design.

## Reference

```
@INPROCEEDINGS{LMOAM,  
    author={Hong, Haokai and Jiang, Min and Feng, Liang and Lin, Qiuzhen and Tan, Kay Chen},
    booktitle={2022 IEEE Congress on Evolutionary Computation (CEC)},
    title={Balancing Exploration and Exploitation for Solving Large-scale Multiobjective Optimization via Attention Mechanism},
    year={2022},
    pages={1-8},
    doi={10.1109/CEC55065.2022.9870430}
}
```

## Usage
* run test_LMOAM in MATLAB