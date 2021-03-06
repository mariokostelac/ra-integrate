# Ra
Integration of the Ra assembler - a de novo DNA assembler for third generation sequencing data developed on Faculty of Electrical Engineering and Computing (FER), Ruder Boskovic Institute (RBI) and Genome Institute of Singapore (GIS).   

Ra is in development since 2014 in the form of several separate components that used to be run individually.  
This project aims to ease the usage of Ra by integrating it into a complete de novo assembly tool.  

Unlike other state-of-the-art assemblers, **Ra does not have an error correction step.** Instead, it relies on detecting overlaps using a very sensitive and specific overlapper ("graphmap -w owler", https://github.com/isovic/graphmap) and constructing and reducing an overlap graph (Ra layout, https://github.com/mariokostelac/ra).  
At this point, the method is still in very early stages of development, and there are many improvements that will be made in the near-by future:  

Thorough testing is still required, but early results are promising:  
- single 4.63Mbp contig **nanopore-only** E. Coli K-12 assembly (```docs/nanopore-contigs_fast.png```) (dataset published by Loman et al. http://www.nature.com/nmeth/journal/v12/n8/full/nmeth.3444.html) in ~10-15 minutes on a laptop. The assembly produces a contiguous circular alignment.  

Example of work in progress:  
- single 4.1Mbp contig **pacbio-only** E. Coli K-12 assembly (http://www.cbcb.umd.edu/software/PBcR/data/selfSampleData.tar.gz). The assembly produces a circular alignment, however, ```contigs_fast.fasta``` contains a large deletion (```docs/pacbio-contigs_fast.png```), probably caused by repeats. For this case, unitigs (```unitigs_fast.fasta```) might be a better choice until we resolve this issue. This is a work in progress, and we welcome any and all suggestions.  

As of yet, Ra does not implement a consensus step, so the output ```contigs_fast.fasta``` has the error rate similar to the input reads. Consensus phase will be added at a later stage. Also, on larger datasets owler gets slower than on the datasets listed above. This is an issue currently being addressed.  

If you have any suggestions/issues, please don't refrain from filing a GitHub Issue!


## Requirements  
- ruby 2.2  
- make  
- g++ (4.8 or later)  
- graphviz  
- maybe some more. If it does not work for you, drop an issue...  

## Installation  
### Easy way (in container)
```
docker pull mariokostelac/ra-integrate:master
```
will get you a container with all dependencies installed and precompiled `ra` assembler (with source code).

After you get it, you can run a new container with
```
docker run -t -i -v ~/shared_dir:/data ra-integrate bash
```
where `~/shared_dir` is shared directory between your OS and `ra` container, mounted as `/data` in container.
`Ra` itself is located in `/ra`.

### Hard and dirty way (compiling + installing dependencies)
```  
git clone --recursive https://github.com/mariokostelac/ra-integrate.git  
make  
```  

## Upgrade  
```  
make upgrade
```  

## Usage  
```  
scripts/run reads.fa  
```  

## Clang Issues or "Build does not work!"  
If you are unlucky and your `g++` points to `clang`, run  
```  
brew install g++-4.8  
CXX=g++-4.8 make  
```  

## Installation of Ruby 2.2 on Ubuntu  
One can follow these instructions:
```  
https://www.brightbox.com/blog/2015/01/05/ruby-2-2-0-packages-for-ubuntu/  
```  
In this case, run Ra using:
```  
ruby2.2 scripts/run reads.fa  
```
