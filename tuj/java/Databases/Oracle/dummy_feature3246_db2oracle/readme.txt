added an option "Use memory saving mode" to each scd component.
if this option is not check , keep the original logic, otherwise using the new logic.
the new logic is described below:
in order to save memory usage
1.it does not load source keys and dimension attributes in the cache in the begin part. 
2.it will to search dimension attributes by using source keys in the main part.