# R: three methods of package installation explained

In our previous lessons, we learned how to install packages using the base R function `install.packages()`. This is just one of 3 important methods of installing useful R bioinformatic tools. The three methods are:
- `install.packages()` for tools maintained in the CRAN repository. Packages that extend/modify core R functionality and mathematical/statistical-focused packages are usually installed this way.
- Bioconductor: a fantastic resource for biologists+bioinformaticians. It comes with it's own installer and methods, however.
- `devtools()` once "devtools" is installed, this is the best way to install packages from github sources (either only found on github, or to install the absolute latest pre-release versions of a tool)

## CRAN install.packages()

We covered this previously. To install a package such as "tidyverse" via `install.packages()`, your commands will look like this:

```
# install from CRAN
install.packages("devtools")
# note the double-quotes. these are NOT optional.
```

to load the package and use it, once installed, use the `library()` function in your script, or from the R console

```
# loading installed libraries
library(tidyverse)
# note how quotes are not required for this function. Consistency, am I right?
```

## Bioconductor

To make use of packages housed at Bioconductor, you must first install Bioconductor. After that, you can install the tools using their installer function. Finally, you'll load the libraries the same as you would for packages installed via CRAN.

This is the current method of installing Bioconductor (v. 3.8, compatible with R version 3.5+)

```
# installing Bioconductor itself
if (!requireNamespace("BiocManager"))
    install.packages("BiocManager")
BiocManager::install()
```

Now that you have the `BiocManager::install()` function, you can install `DESeq2` like this

```
BiocManager::install("DESeq2")
```

You can also specify multiple packages at once, using the `c()` vector contatenator function. Here, the `Rsubread` and `edgeR` packages

```
BiocManager::install(c("Rsubread", "edgeR"))
```


To load the package(s) and use them, once installed, use the `library()` function in your script, or from the R console

```
# loading installed libraries
library(DESeq2)
library(Rsubread)
library(edgeR)
```

## Installing from github via devtools

This one is a bit complicated, and I won't cover in class. If you need something only found on a github page, let me know, and I'll help you with it. The instructions are very OS-dependent, unfortunately. If you wish to tackle it without my help, try following the instructions found here:[https://www.r-project.org/nosvn/pandoc/devtools.html](https://www.r-project.org/nosvn/pandoc/devtools.html)
