#`run_pipeline.sh`.

# USAGE: bash run_pipeline.sh
# to produce plots for isles and abyss
# and the summary table for the Zipf's law tests

python snakemake/wordcount.py data/dracula.txt results/dracula.dat
python snakemake/wordcount.py data/moby_dick.txt results//moby_dick.dat

python snakemake/plotcount.py  results/dracula.dat results/dracula.png
python snakemake/plotcount.py results/moby_dick.dat results/moby.png

# Generate summary table
python snakemake/zipf_test.py results/moby_dick.dat results/dracula.dat > results/bash_pipeline_results.txt 
