#' Function to calculate descriptive statistics for a variable
#'
#' @param variable is a vector of the variable
#' @param name is the name of the variable
#' @keywords descriptive, statistics, summary
#' @return a vector with a list of descriptive statistics
#' @example ds.summary(studierende$Größe, "Körpergroesse (in cm)")
#' @export
ds.summary <- 
function(variable, name) {
    var       <- as.data.frame(table(variable))
    var.n     <- length(variable)
    var.na    <- sum(is.na(variable))
    var.maxanzahl   <- max(var$Freq)
    var.suche <- dplyr::filter(var, var$Freq == var.maxanzahl)
    var.modus <- as.character(var.suche$variable)
    var.median<- ifelse(is.numeric(variable), stats::median(variable, na.rm = TRUE),NA)
    var.mean  <- ifelse(is.numeric(variable), mean(variable, na.rm = TRUE),NA)
    var.skewness <- e1071::skewness(variable)                       # Schiefe
    var.skewness.txt<- new("character")
    if (!is.na(var.skewness)) {
      if (var.skewness<0){ 
        var.skewness.txt<-paste("Schiefe",var.skewness,"< 0, Linke Schiefe: negative Schiefe, linksschief, rechtssteil")
      } else if (var.skewness>0){
        var.skewness.txt<-paste("Schiefe",var.skewness,"> 0, Rechte Schiefe: positive Schiefe, linkssteil, rechtsschief")
      } else {
        var.skewness.txt<-paste("Schiefe",var.skewness,"Näherungsweise Normalverteilt")
      }
    } else {
      var.skewness.txt<- NA
    }
    var.kurtosis <- e1071::kurtosis(variable)
    if (!is.na(var.kurtosis)) {
      if (var.kurtosis<0){ 
        var.kurtosis.txt<-paste("Exzess Kurtosis",var.kurtosis,"< 0, flachgipflig")
      } else if (var.kurtosis>0){
        var.kurtosis.txt<-paste("Exzess Kurtosis",var.kurtosis,"> 0, steilgipflig")
      } else {
        var.kurtosis.txt<-paste("Exzess Kurtosis",var.kurtosis,"Näherungsweise Normalverteilt")
      }
    } else {
      var.kurtosis.txt<- NA
    }  
    var.min   <- ifelse(is.numeric(variable), min(variable),NA)
    var.max   <- ifelse(is.numeric(variable), max(variable),NA)
    var.spannweite <- var.max - var.min
    var.var   <- ifelse(is.numeric(variable), stats::var(variable),NA)
    var.sd    <- ifelse(is.numeric(variable), stats::sd(variable),NA)
    var.gesamt <- rbind(var.n,var.na,var.maxanzahl,var.modus,var.median,var.mean,var.skewness,var.skewness.txt,var.kurtosis, var.kurtosis.txt, var.spannweite,var.min,var.max,var.var,var.sd)
    rownames(var.gesamt)<-c("n","na","maxanzahl","modus","median","mean","skewness","skewness.txt","kurtosis","kurtosis.txt","spannweite","min","max","var","sd")
    if (is.numeric(variable)){
            graphics::hist(variable, xlab="",ylab="Häufigkeit",main=name)
      graphics::abline(v=c(var.mean,var.median,var.modus),col=(c("red","blue","darkgreen")), lwd=2)
      graphics::boxplot(variable,data=variable,main=name,xlab="",ylab="")
    } else {
      graphics::par(oma=c(2,0,0,0))                                 # Platz für Labels
      graphics::barplot(table(variable), space = 0,                 # Space zwischen Balken
              ylab = "Häufigkeit", main = name,
              border="black", col="grey",las=2)
    }
    return(var.gesamt)
}
