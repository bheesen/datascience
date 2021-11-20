#' Function to start a tutorial accompanying the package "datascience" and the book "Data Science und Statistik mit R" if
#' you have received a password from Professor Heesen (access limited to selected group only) validating your access rights.
#'
#' @param name is the name of the tutorial
#' @keywords tutorial
#' @example ds.tutorial(name = "ds.syntax")
#' @export

ds.tutorial <-  function(name){
  t <- Sys.Date()
  z<-as.numeric(format(t, format="%Y"))-1362
  s<-as.numeric(format(t, format="%m"))
  if (s>2) {
    x<-s-2
    b<-a[z,x:s] }
  else if (s==2) {
    x<-s-1
    y<-z-1
    b<-c(a[z,x:s],a[y,12]) }
  else {
    y<-z-1
    b<-c(a[z,s],a[y,11:12])
  }
  passwort <- rstudioapi::askForPassword(
    prompt="Passwort erforderlich! Bitte geben Sie das Berechtigungspasswort ein, welches Sie von Professor Heesen erhalten haben.")
  if (passwort %in% b)
    learnr::run_tutorial(name, package = "datascience")
  else
    return("Ungültiges Passwort!")
}  
