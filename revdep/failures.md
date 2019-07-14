# BioNetStat

<details>

* Version: 1.4.0
* Source code: https://github.com/cran/BioNetStat
* URL: http://github.com/jardimViniciusC/BioNetStat
* BugReports: http://github.com/jardimViniciusC/BioNetStat/issues
* Date/Publication: 2019-05-02
* Number of recursive dependencies: 114

Run `revdep_details(,"BioNetStat")` for more info

</details>

## In both

*   checking whether package ‘BioNetStat’ can be installed ... ERROR
    ```
    Installation failed.
    See ‘/Users/jenny/rrr/whisker/revdep/checks.noindex/BioNetStat/new/BioNetStat.Rcheck/00install.out’ for details.
    ```

## Installation

### Devel

```
* installing *source* package ‘BioNetStat’ ...
** using staged installation
** R
** data
** inst
** byte-compile and prepare package for lazy loading
Error: package ‘org.Hs.eg.db’ required by ‘pathview’ could not be found
Execution halted
ERROR: lazy loading failed for package ‘BioNetStat’
* removing ‘/Users/jenny/rrr/whisker/revdep/checks.noindex/BioNetStat/new/BioNetStat.Rcheck/BioNetStat’

```
### CRAN

```
* installing *source* package ‘BioNetStat’ ...
** using staged installation
** R
** data
** inst
** byte-compile and prepare package for lazy loading
Error: package ‘org.Hs.eg.db’ required by ‘pathview’ could not be found
Execution halted
ERROR: lazy loading failed for package ‘BioNetStat’
* removing ‘/Users/jenny/rrr/whisker/revdep/checks.noindex/BioNetStat/old/BioNetStat.Rcheck/BioNetStat’

```
# geoknife

<details>

* Version: 1.6.3
* Source code: https://github.com/cran/geoknife
* URL: https://github.com/USGS-R/geoknife
* BugReports: https://github.com/USGS-R/geoknife/issues
* Date/Publication: 2019-01-30 22:33:52 UTC
* Number of recursive dependencies: 82

Run `revdep_details(,"geoknife")` for more info

</details>

## Newly fixed

*   checking examples ... ERROR
    ```
    Running examples in ‘geoknife-Ex.R’ failed
    The error most likely occurred in:
    
    > ### Name: cancel
    > ### Title: cancel a geo-web processing request
    > ### Aliases: cancel cancel,geojob-method cancel,missing-method
    > ### Keywords: methods
    > 
    > ### ** Examples
    > 
    > wd <- webdata('prism')
    > wg <- webgeom('state::New Hampshire')
    > wp <- webprocess()
    retrying...
    > gj <- geojob()
    > xml(gj) <- XML(wg, wd, wp)
    Error in is.null(template) || template == "" : 
      'length(x) = 71 > 1' in coercion to 'logical(1)'
    Calls: XML -> XML -> <Anonymous>
    Execution halted
    ```

## In both

*   R CMD check timed out
    

