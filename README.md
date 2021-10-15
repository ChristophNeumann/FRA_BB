# Feasible Rounding Appraoches and Diving Strategies
This project implements feasible rounding approaches combined with branch-and-bound search outlined in this paper [Feasible rounding approaches and diving strategies in branch-and-bound methods for mixed-integer optimization](http://www.optimization-online.org/DB_HTML/2021/10/8630.html).
It makes use of so-called inner parallel sets (IPS) of the original feasible set to guarantee feasibility of roundings.

## Table of contents
* [General info](#general-info)
* [Setup](#setup)
* [Code Examples](#code-examples)
* [Reproducing the experiments](#reproducing-the-experiments)
* [Contact](#contact)

## General info
This project is a prototype of objective-IPS-diving and feasibility-IPS-diving that can be applied to Pyomo models. It is mainly intended for researchers to experiment and compare computational results on their MICP instances and to enable an easy reproducibility of the computational results of the above article. 

As a gerenal note, under a Gams license, you may convert any (other) Gams-model to a Pyomo model and then apply the IPCP. This process is described [here](https://www.gams.com/latest/docs/S_CONVERT.html). 

## Setup
The method has been tested under Matlab R2020a. For solving the sub-LPs it uses Gurobi as LP-solver which needs to be installed. 

You can run the test 
```
testscripts/runTests
```
to see if the method is running correctly.

## Code Examples
The following runs the diving method on Example 4.1 from the above article.

```
params.mode = 'MC'; %Can be 'MC'(max constraints - greedy) or 'RA'(random)
params.maxIter = 30;

%Model from Example 4.1. 
model.obj = [-1;0;-3];
model.A = sparse([1,1,2;-2,-2,1]);
model.lb = transpose(repelem(0,3));
model.ub = transpose(repelem(2,3));
model.rhs = [3;-1];
model.vtype = repelem('I',3);
model.sense = transpose(repelem('<',2));

%FRA_diving_heuristic first executes feasibility diving and, after arriving
%at a granular node, optimality diving.

resultsDiving = FRA_diving_heuristic(model, params);
fprintf('depth of the first granular node is %i \n',resultsDiving.depth0) 
fprintf('point found by diving is: ')
resultsDiving.xy
fprintf('objective value of the feasible point is %i \n',resultsDiving.objVal)
```

which returns:

```
Running Feasibility diving
Diving successful at depth 0
Running Optimality diving
Optimality Diving from root node.
Updating v_check from Inf to -2.00 at depth 0 
depth of the first granular node is 0 
point found by diving is: 
ans =

     2
     0
     0

objective value of the feasible point is -2 
```

This example is contained in the script `exampleDiving.m`.


## Reproducing the experiments

The computational experiments from  [Feasible rounding approaches and diving strategies in branch-and-bound methods for mixed-integer optimization](http://www.optimization-online.org/DB_HTML/2021/10/8630.html) may be reproduced by running the scripts 

```
runDivingOnMIPLIBInstances.m
```
These scripts needs a path to stored MIPLIB-instances which can be downloaded at [this website](https://miplib.zib.de/). 

The folder `resultAnalysisPython` contains an excel file of the results along with a jupyter notebook where the analysis of the paper is done. 

## Contact
Christoph.Neumann@kit.edu

