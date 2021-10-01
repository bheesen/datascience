#' Function to start a tutorial accompanying the package "datascience" and the book "Data Science und Statistik mit R"
#'
#' @param name is the name of the tutorial
#' @keywords tutorial
#' @example tutorial.heesen(name = "Tutorial-R-1")
#' @export
tutorial.heesen <- 
  function(name) {
    learnr::run_tutorial(name, package = "datascience")
  }
