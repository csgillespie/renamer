
add_underscore = function(value, indx=0){
  if(indx == -1) return(value)
  nc = nchar(value)
  ss = substr(value, indx+1, max(nc, indx+1))
  
  new_split = regexpr("[A-Z]", ss)
  if(indx == 0 )  add_underscore(ss, new_split)
  else  {
    underscored = paste0(substr(value, 1, indx-1L), "_", 
                         tolower(substr(value, indx, indx)),
                         add_underscore(ss, new_split))
    
    ## Remove initial _ if the first letter is a [A-Z]
    gsub("^_", "", underscored)
  }
}


parse_ns = function(package, package.lib)
{
  ns = parseNamespaceFile(package, package.lib)
  values = ns$exports
  
  bad_names = regexpr("[A-Z]", values)
  bad_names = values[bad_names > 0]
  ss = sapply(bad_names, add_underscore)
  
  names(bad_names) = as.vector(ss)
  bad_names
}

func_gen = function(old_func) {
  function(...) do.call(old_func, list(...))
}

find_package = function(package){
  lp = .libPaths()
  find_package = file.exists(paste(lp, package, sep="/"))
  if(sum(find_package) > 2) {
    stop("This package is installed in multiple places. Please specify prefered
         package.lib location")
  }
  if(sum(find_package) == 0) {
    stop("Package doesn't seem to be installed. Please install the package
         and try again.")
  }
  lp[find_package]
}

#' Detect and create underscored aliases
#' 
#' This package scans the list of exported functions and creates 
#' underscored variants. For example, \sQuote{plotLike} becomes \sQuote{plot_lik}
#' @param package name (as a character string)
#' @param package.lib character vector specifying library. The default \code{NULL}, will 
#' search through \code{.libPaths()} for location of package.
#' @export
underscore = function(package, package.lib=NULL)
{
  if(!require(package, character.only = TRUE)) 
    stop("Package ", package, " not found")  
  
  if(is.null(package.lib)) package.lib= find_package(package)
  ## Get bad names and new __ alternatives
  bad_names = parse_ns(package, package.lib)
  ## Create new functions
  l = lapply(bad_names, func_gen)
  ## Add to the global workspace
  list2env(l, globalenv())
  message("Created: ", paste(names(bad_names), collapse = ", "))
  invisible(NULL)
}



# make_function <- function(args, body, env = parent.frame()) {
#   args <- as.pairlist(args)
#   eval(call("function", args, body), env)
# }
