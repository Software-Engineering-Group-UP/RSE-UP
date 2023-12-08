
## Chapter Configuration

### Exercise 1

The build rule involving `plotcounts.py` should now read:

```makefile
## results/collated.png: plot the collated results.
results/collated.png : results/collated.csv $(PARAMS)
	python $(PLOT) $< --outfile $@ --plotparams $(word 2,$^)
```

where `PARAMS` is defined earlier in the `Makefile`
along with all the other variables and
also included later in the settings build rule:

```makefile
COUNT=bin/countwords.py
COLLATE=bin/collate.py
PARAMS=bin/plotparams.yml
PLOT=bin/plotcounts.py
SUMMARY=bin/book_summary.sh
DATA=$(wildcard data/*.txt)
RESULTS=$(patsubst data/%.txt,results/%.csv,$(DATA))
```

```makefile
## settings : show variables' values.
settings :
	@echo COUNT: $(COUNT)
	@echo DATA: $(DATA)
	@echo RESULTS: $(RESULTS)
	@echo COLLATE: $(COLLATE)
	@echo PARAMS: $(PARAMS)
	@echo PLOT: $(PLOT)
	@echo SUMMARY: $(SUMMARY)
```

### Exercise 2 

1. Make the following additions to `plotcounts.py`:

```python
import matplotlib.pyplot as plt
```

```python
parser.add_argument('--style', type=str,
                    choices=plt.style.available,
                    default=None, help='matplotlib style')
```

```python
def main(args):
    """Run the command line program."""
    if args.style:
        plt.style.use(args.style)
```

3. Add `nargs='*'` to the definition of the `--style` option:

```python
parser.add_argument('--style', type=str, nargs='*',
                    choices=plt.style.available,
                    default=None, help='matplotlib style')
```

### Exercise 3

The first step is to add a new command-line argument to tell `plotcount.py` what we want to do:

```python
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    # ...other options as before...
    parser.add_argument('--saveconfig', type=str, default=None,
                        help='Save configuration to file')
    args = parser.parse_args()
    main(args)
```

Next, we add three lines to `main` to act on this option *after* all of the plotting parameters have been set.
For now we use `return` to exit from `main` as soon as the parameters have been saved;
this lets us test our change without overwriting any of our actual plots.

```python
def save_configuration(fname, params):
    """Save configuration to a file."""
    with open(fname, 'w') as reader:
        yaml.dump(params, reader)


def main(args):
    """Run the command line program."""
    if args.style:
        plt.style.use(args.style)
    set_plot_params(args.plotparams)
    if args.saveconfig:
        save_configuration(args.saveconfig, mpl.rcParams)
        return
    df = pd.read_csv(args.infile, header=None,
                     names=('word', 'word_frequency'))
    # ...carry on producing plot...
```

Finally, we add a target to `Makefile` to try out our change.
We do the test this way so that we can be sure that
we're testing with the same options we use with the real program;
if we were to type in the whole command ourselves,
we might use something different.
We also save the configuration to `/tmp` rather than to our project directory
to keep it out of version control's way:

```makefile
## test-saveconfig : save plot configuration.
test-saveconfig :
	python $(PLOT) --saveconfig /tmp/test-saveconfig.yml \
	  --plotparams $(PARAMS)
```

The output is over 400 lines long,
and includes settings for everything from the animation bit rate to the size of y-axis ticks:

```yaml
!!python/object/new:matplotlib.RcParams
dictitems:
  _internal.classic_mode: false
  agg.path.chunksize: 0
  animation.avconv_args: []
  animation.avconv_path: avconv
  animation.bitrate: -1
  ...
  ytick.minor.size: 2.0
  ytick.minor.visible: false
  ytick.minor.width: 0.6
  ytick.right: false
```

The beautiful thing about this file is that the entries are automatically sorted alphabetically,
which makes it easy for both human beings and the `diff` command to spot differences.
This helps reproducibility because any one of these settings might change
in a new release of `matplotlib`,
and any of those changes might affect our plots.
Saving the settings allows us to compare what we had when we did our work
to what we have when we're trying to re-create it,
which in turn gives us a starting point for debugging if we need to.


### Exercise 4

```python
import configparser


def set_plot_params(param_file):
    """Set the matplotlib parameters."""
    if param_file:
        config = configparser.ConfigParser()
        config.read(param_file)
        for section in config.sections():
            for param in config[section]:
                value = config[section][param]
                mpl.rcParams[param] = value
```

1.  Most people seem to find Windows INI files easier to write and read,
    since it's easier to see what's a heading and what's a value.

2.  However, Windows INI files only provide one level of sectioning,
    so complex configurations are harder to express.
    Thus, while YAML may be a bit more difficult to get started with,
    it will take us further.

### Exercise 5

The answer depends on whether we are able to make changes to Program A and Program B. If we can, we can modify them to use overlay configuration
and put the shared parameters in a single file that both programs load.
If we can't do that, the next best thing is to create a small helper program
that reads their configuration files and checks that common parameters have consistent values. 
The first solution prevents the problem; the second detects it, which is a lot better than nothing.
