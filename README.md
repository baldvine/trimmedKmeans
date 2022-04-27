# Trimmed k-means clustering algorithm

Simple shiny app to visualize several datasets and the trimmed k-means algorithm. Application is hosted here: <a href="https://baldvine.shinyapps.io/trimmedKmeans/" target="_blank">https://baldvine.shinyapps.io/trimmedKmeans/</a>

The default dataset is the ruspini dataset (from the *cluster* package), which has 4 distinct clusters. There are multiple data sets to choose from. 

Note that the method has a random aspect to it. See <a href="https://github.com/baldvine/initializeKmeans/" target="_blank">https://github.com/baldvine/initializeKmeans/</a> for several methods to initialize the standard k-means algorithm.

## References

1. Heinrich Fritz, Luis A. Garcia-Escudero, Agustin Mayo-Iscar (2012). tclust: An R Package for a Trimming Approach to Cluster
  Analysis. *Journal of Statistical Software*, 47(12), pp.1-26. URL https://www.jstatsoft.org/v47/i12/.

2. Garcia-Escudero, L.A. and Gordaliza, A. Robustness properties of k means and trimmed k means. *Journal of the American Statistical Association*, 94(447), pp.956-969. 1999.

3. Garcia-Escudero, L.A., Gordaliza, A., Matran, C. and Mayo-Iscar, A. A general trimming approach to robust cluster analysis. *The Annals of Statistics*, 36(3), pp.1324-1345. 2008
