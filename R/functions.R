
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

add_CamelCase = function(value, indx=0){
  if(indx == -1) return(value)
  nc = nchar(value)
  ss = substr(value, indx+2, max(nc, indx+2))
  
  new_split = regexpr("_", ss)
  if(indx == 0 )  add_CamelCase(value, regexpr("_", value))
  else  {
    camel_case = paste0(substr(value, 1, indx-1L),  
                        toupper(substr(value, indx+1, indx+1)),
                        add_CamelCase(ss, new_split))
    
    ## Remove initial _ if the first letter is a [A-Z]
    #gsub("^_", "", underscored)
    camel_case
  }
}

get_bad_names = function(package, package.lib, 
                         pattern, add)
{
  ns = parseNamespaceFile(package, package.lib)
  values = ns$exports
  
  bad_names = regexpr(pattern, values)
  bad_names = values[bad_names > 0]
  ss = sapply(bad_names, add)
  
  names(bad_names) = as.vector(ss)
  bad_names
}


func_gen = function(old_func) {
  force(old_func)
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

get_package_lib = function(package, package.lib=NULL)
{
  if(!require(package, character.only = TRUE)) 
    stop("Package ", package, " not found")  
  if(is.null(package.lib)) package.lib = find_package(package)
  package.lib
}

create_functions = function(bad_names) {
  ## Create new functions
  l = lapply(bad_names, func_gen)
  ## Add to the global workspace
  list2env(l, globalenv())
  message("Created: ", paste(names(bad_names), collapse = ", "))
  invisible(l)
}





