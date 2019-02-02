#-------------------------------------------------------------------------------
#' Helper ot quickly create a heatmap for a 'probability' like data matrix,
#' i.e. where the values range between 0 and 1
#'
#' @params data The data matrix for which the values are to be plotted
#' @params cluster Whether to perform clustering for rows and cols. Default: FALSE
#' @params dilution Dilution of colors. Think of it as 'how many colors to use'. Default: 20
#' @params ... Additional parameters to be passed to pheatmap()
#'
#' @author Johann Hawe <johann.hawe@helmholtz-muenchen.de>
#-------------------------------------------------------------------------------
probability_map <- function(data, cluster = F,
                            dilution = 20, ...) {
  require(pheatmap)
  require(RColorBrewer)

  if(dilution < 2) stop("Dilution value must be larger than 1")

  # get custom color definition
  bk <- seq(0, 1, length=dilution)
  bp <- brewer.pal(9, "Purples")
  cols <- colorRampPalette(bp[c(1,5,9)])(dilution)
  pheatmap(data, cluster_cols=cluster, cluster_rows = cluster,
           breaks=bk, color = cols, ...)

}

#-------------------------------------------------------------------------------
#' Helper ot quickly create a heatmap for a 'correlation' like data matrix,
#' i.e. where the values range between -1 and 1
#'
#' @params data The data matrix for which the values are to be plotted
#' @params cluster Whether to perform clustering for rows and cols
#' @params dilution Dilution of colors. Think of it as 'how many colors to use'
#' @params ... Additional parameters to be passed to pheatmap()
#'
#' @author Johann Hawe <johann.hawe@helmholtz-muenchen.de>
#-------------------------------------------------------------------------------
correlation_map <- function(data, cluster = F,
                            dilution = 20, ...) {
  require(pheatmap)
  require(RColorBrewer)

  if(dilution < 2) stop("Dilution value must be larger than 1")

  # get custom color definition
  bk <- seq(-1, 1, length=dilution)
  bp <- brewer.pal(7, "RdYlBu")
  cols <- colorRampPalette(bp[c(1,4,7)])(dilution)
  pheatmap(data, cluster_cols=cluster, cluster_rows = cluster,
           breaks=bk, color = cols, ...)
}
