# The renamer Package

Tired of the [disparate naming](journal.r-project.org/archive/2012-2/RJournal_2012-2_Baaaath.pdf) systems in R? Then this is the package for you. 

The package is located in my `drat` repo, and the latest version can be installed via
```
install.packages("renamer", repos="http://csgillespie.github.io/drat", type="source")
```
or if you have [drat](http://dirk.eddelbuettel.com/code/drat.html) installed
```{r}
drat::addRepo("csgillespie")
install.packages("renamer")
```

## Example: The CamelCaseR

If have an unnatural fear of underscores, that prevents the use of `ggplot2`, then you are saved
```r
## Assumes you have ggplot2 installed
library(renamer)
camelCase("ggplot2")
```
Then
```r
data(cars)
ggplot(cars) + geomPoint(aes(speed, dist))
```

## Example: The UnderscoreR

If you've want to try the excellent `drat` package, but you find the lack of underscores 
unnerving, you too are saved
```r
library(renamer)
install.packages("drat", repos="http://eddelbuettel.github.io/drat")
under_score("drat")
```
The examples on the [drat](https://github.com/eddelbuettel/drat) homepage become
```r
add_repo("eddelbuettel")
insert_package("drat_0.0.1.tar.gz")
```

## Future directions

Now that the problem with the R naming system has been solved, the next logical step is
to remove differences *between* languages
 * `lisp` converter - randomly add brackets to all functions
 * `python` - insert spaces/tabs on every line
 * `FORTRAN` - all code starts on the eighth column


