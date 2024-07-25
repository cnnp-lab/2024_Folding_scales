# About this repo
This repo contains the analysis code underpinning our paper "Neuro-evolutionary evidence for a universal fractal primate brain shape" [eLife 2024](https://elifesciences.org/reviewed-preprints/92080). 
It relies on a data folder to run, which be found on zenodo: [DOI:10.5281/zenodo.12820611](http://).

The data folder contains files that are outputs from our multiscale pipeline in the [Cortical Folding Analysis Toolbox](https://github.com/cnnp-lab/CorticalFoldingAnalysisTools) so anyone can easily reproduce the main results in the paper without having obtain the raw data and re-run the multiscale pipeline. We made sure not to replicate any data from other sources in the zenodo data package, but restrict it to only the multiscale outputs where possible.

## Brief summary of the paper
The paper [eLife 2024](https://elifesciences.org/reviewed-preprints/92080) introduces a new way of conceptualising brain shape as a function of spatial scale. 
* Fig. 2 in the paper shows that the brain shape in 11 primate species (including human) agree in their fractal dimension (which measures how shape measures relate to each other as a function of scale).
* Fig. 3 in the paper demonstrates further that all 11 primate species are indeed derived from a single universal fractal shape.
* Fig. 4 shows in proof-of-concept how this new way of conceptualising brain shape as a function of spatial scale can be used as a shape biomarker to better detect e.g. differences between old and young subjects.

## Reproducing the main results figures in the paper

Code to reproduce figures 2-4 are included in the subfolder 'analysis'. In MATLAB, once you have included the 'lib' folder, you should be able to just click run on each of the matlab .m files for each figure. More details are in the code itself.
Note that the code currently assumes that the 'data' folder is on the same level as the 'lib' and 'analysis' folders. Otherwise, please change the code, or move your folder.

## Where to obtain the original data on the primate species

Full references are given in the paper, but below are the main data sources:

[NIH Marmoset Atlas](https://www.nitrc.org/projects/nih_marmoset/)

[Primate Brain Bank MRI](https://zenodo.org/records/5044936)

## Running the multiscale pipeline on your own data

Please see our toolbox repo for further details:
[Cortical Folding Analysis Toolbox](https://github.com/cnnp-lab/CorticalFoldingAnalysisTools)

## Have further questions?

Please contact Yujiang.Wang@ncl.ac.uk
