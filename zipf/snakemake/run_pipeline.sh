#`run_pipeline.sh`.

# USAGE: bash run_pipeline.sh
# to produce plots for isles and abyss
# and the summary table for the Zipf's law tests

python wordcount.py ../data/dracula.txt ../data/dracula.dat
python wordcount.py ../data/moby_dick.txt ../data/moby_dick.dat

python plotcount.py ../data/dracula.dat drac.png
python plotcount.py ../data/moby_dick.dat moby.png

# Generate summary table
python zipf_test.py ../data/moby_dick.dat ../data/dracula.dat > ../data/results.txt 
