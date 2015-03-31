
#' The alias creators
#' 
#' This package scans the list of exported functions and creates either 
#' underscored or camelCase variants. For example, \sQuote{plotLike} becomes \sQuote{plot_lik} 
#' and \sQuote{geom_point} becomes \sQuote{geomPoint}
#' @param package name (as a character string)
#' @param package.lib character vector specifying library. The default \code{NULL}, will 
#' search through \code{.libPaths()} for location of package
#' @aliases camelCase.
#' @export
under_score = function(package, package.lib=NULL)
{
  package.lib = get_package_lib(package, package.lib=NULL)
  ## Get bad names and new __ alternatives
  bad_names = get_bad_names(package, package.lib, "[A-Z]", add_underscore)
  create_functions(bad_names)
}

#' @export
#' @rdname under_score
camelCase = function(package, package.lib=NULL)
{
  package.lib = get_package_lib(package, package.lib=NULL)
  ## Get bad names and new CC alternatives
  bad_names = get_bad_names(package, package.lib, "_", add_CamelCase)
  create_functions(bad_names)
}
