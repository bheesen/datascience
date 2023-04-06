#' Function to start a tutorial accompanying the package "datascience" and the book "Data Science und Statistik mit R".
#'
#' @param name is the name of the tutorial
#' @keywords tutorial
#' @example ds.tutorial(name = "ds.syntax")
#' @export

ds.tutorial <-  function(name){
  learnr::run_tutorial(name, package = "datascience")
}  
