#
# Author : Bernd Heesen
#

##---Functions---------------------------------------------------------------------------------

# Descriptive statistics function
#' Function to calculate descriptive statistics for a variable
#'
#' @param variable is a vector of the variable
#' @param name is the name of the variable
#' @keywords descriptive, statistics
#' @return a vector with a list of descriptive statistics
#' @example descriptive(studierende$Groesse, "Koerpergroesse (in cm)")
  descriptive <- function(variable, name) {
    var       <- as.data.frame(table(variable))
    var.n     <- length(variable)
    var.na    <- sum(is.na(variable))
    var.maxanzahl   <- max(var$Freq)
    var.suche <- dplyr::filter(var, var$Freq == var.maxanzahl)
    var.modus <- as.character(var.suche$variable)
    var.median<- ifelse(is.numeric(variable), stats::median(variable, na.rm = TRUE),NA)
    var.mean  <- ifelse(is.numeric(variable), mean(variable, na.rm = TRUE),NA)
    var.min   <- ifelse(is.numeric(variable), min(variable),NA)
    var.max   <- ifelse(is.numeric(variable), max(variable),NA)
    var.spannweite <- var.max - var.min
    var.var   <- ifelse(is.numeric(variable), stats::var(variable),NA)
    var.sd    <- ifelse(is.numeric(variable), stats::sd(variable),NA)
    var.gesamt <- rbind(var.n,var.na,var.maxanzahl,var.modus,var.median,var.mean,var.spannweite,var.min,var.max,var.var,var.sd)
    if (is.numeric(variable)){
      graphics::hist(variable, xlab="",ylab="Haeufigkeit",main=name)
      graphics::abline(v=c(var.mean,var.median,var.modus),col=(c("red","blue","darkgreen")), lwd=2)
      graphics::boxplot(variable,data=variable,main=name,xlab="",ylab="")
    } else {
      graphics::par(oma=c(2,0,0,0))                                 # Platz für Labels
      graphics::barplot(table(variable), space = 0,                 # Space zwischen Balken
              ylab = "Haeufigkeit", main = name,
              border="black", col="grey",las=2)
      graphics::abline(v=c(var.mean,var.median,var.modus),col=(c("red","blue","darkgreen")), lwd=2)
    }
    return(var.gesamt)
  }
