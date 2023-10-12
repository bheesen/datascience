#' Function to calculate descriptive statistics for a variable
#'
#' @param variable is a vector of the variable
#' @param titel is the name of the variable to be used as title on diagrams
#' @param achse is the description of the axis on diagrams
#' @keywords descriptive, statistics, summary
#' @return a vector with a list of descriptive statistics
#' @example ds.summary(studierende$Größe, "Körpergroesse (in cm)")
#' @export
ds.summary<-function (variable,titel="Titel",achse="Achse") 
{
  var.df      <- as.data.frame(variable)
  var         <- as.data.frame(table(variable))
  var.n       <- length(variable)
  var.na      <- sum(is.na(variable))
  var.maxanzahl<- max(var$Freq)
  var.suche   <- dplyr::filter(var, var$Freq == var.maxanzahl)
  var.modus   <- as.character(var.suche$variable)
  var.median  <- ifelse(is.numeric(variable),stats::median(variable,na.rm=TRUE),NA)
  var.mean     <- ifelse(is.numeric(variable),mean(variable,na.rm=TRUE),NA)
  var.skewness <- e1071::skewness(variable)
  var.skewness.txt <- new("character")
  if (!is.na(var.skewness)) {
    if (var.skewness < 0) {
      var.skewness.txt <- paste("Schiefe", var.skewness, 
                                "< 0, Linke Schiefe: negative Schiefe, linksschief, rechtssteil")
    }
    else if (var.skewness > 0) {
      var.skewness.txt <- paste("Schiefe", var.skewness, 
                                "> 0, Rechte Schiefe: positive Schiefe, linkssteil, rechtsschief")
    }
    else {
      var.skewness.txt <- paste("Schiefe", var.skewness, 
                                "Näherungsweise Normalverteilt")
    }
  }
  else {
    var.skewness.txt <- NA
  }
  var.kurtosis <- e1071::kurtosis(variable)
  if (!is.na(var.kurtosis)) {
    if (var.kurtosis < 0) {
      var.kurtosis.txt <- paste("Exzess Kurtosis", var.kurtosis, 
                                "< 0, flachgipflig")
    }
    else if (var.kurtosis > 0) {
      var.kurtosis.txt <- paste("Exzess Kurtosis", var.kurtosis, 
                                "> 0, steilgipflig")
    }
    else {
      var.kurtosis.txt <- paste("Exzess Kurtosis", var.kurtosis, 
                                "Näherungsweise Normalverteilt")
    }
  }
  else {
    var.kurtosis.txt <- NA
  }
  var.min <- ifelse(is.numeric(variable), min(variable), NA)
  var.max <- ifelse(is.numeric(variable), max(variable), NA)
  var.spannweite <- var.max - var.min
  var.var <- ifelse(is.numeric(variable), stats::var(variable), 
                    NA)
  var.sd <- ifelse(is.numeric(variable), stats::sd(variable), 
                   NA)
  var.gesamt <- rbind(var.n, var.na, var.maxanzahl, var.modus, 
                      var.median, var.mean, var.skewness, var.skewness.txt, 
                      var.kurtosis, var.kurtosis.txt, var.spannweite, var.min, 
                      var.max, var.var, var.sd)
  rownames(var.gesamt) <- c("n", "na", "maxanzahl", "modus", 
                            "median", "mean", "skewness", "skewness.txt", "kurtosis", 
                            "kurtosis.txt", "spannweite", "min", "max", "var", "sd")
  if (is.numeric(variable)) {
    var.modus <- as.numeric(var.modus)
    p1 <- ggplot2::ggplot(var.df) + ggplot2::aes(x = variable) + 
      ggplot2::labs(title="Histogramm",subtitle=titel, 
                    x=achse,y="Häufigkeit") + 
      ggplot2::geom_histogram(col="white",bins=30) + 
      ggplot2::geom_vline(ggplot2::aes(xintercept = var.median, 
                                       color = "Median", linetype = "Median"), linewidth = 1) + 
      ggplot2::geom_vline(ggplot2::aes(xintercept = var.mean, 
                                       color = "Mittelwert", linetype = "Mittelwert"), linewidth = 2) + 
      ggplot2::geom_vline(ggplot2::aes(xintercept = var.modus[1], 
                                       color = "Modus", linetype = "Modus"), linewidth = 1) + 
      ggplot2::scale_color_manual(name = "Kennzahl", values = c(Mittelwert   = "red", 
                                                                Median = "blue",
                                                                Modus  = "darkgreen")) + 
      ggplot2::scale_linetype_manual(name = "Kennzahl", 
                                     values = c(Mittelwert  = "solid", 
                                                Median= "dashed", 
                                                Modus = "dotted"))
    gridExtra::grid.arrange(p1, nrow = 1, ncol = 1)
    p1 <- ggplot2::ggplot(var.df) + ggplot2::aes(x = variable) + 
      ggplot2::geom_boxplot() + ggplot2::coord_flip() + 
      ggplot2::labs(title = "Box-Plot", subtitle = titel, 
                    x=achse,y=NULL,ylab=NULL) + 
      ggplot2::theme(axis.ticks.x = ggplot2::element_blank(), 
                     axis.text.x = ggplot2::element_blank())
    gridExtra::grid.arrange(p1, nrow = 1, ncol = 1)
  }
  else {
    var.df<-as.data.frame(variable)
    colnames(var.df)<-c("daten")
    tab.daten<-table(var.df$daten)
    var.df.x<-data.frame(x=tab.daten)
    colnames(var.df.x)<-c("y","x")
    if (is.factor(var.df.x$y) | is.ordered(var.df.x$y)) {
      p.bar<-ggplot2::ggplot(var.df.x)+                          
        ggplot2::aes(x=x,y=y,fill=y)+
        ggplot2::geom_bar(position="dodge",stat="identity")+
        ggplot2::labs(title="Bar-Chart",subtitle=titel,x="Anzahl",y=achse)+
        ggplot2::theme(legend.position = "none")
    }
    else {
      p.bar<-ggplot2::ggplot(df.x)+                          
        ggplot2::aes(x=x,y=reorder(y,x),fill=y)+
        ggplot2::geom_bar(position="dodge",stat="identity")+
        ggplot2::labs(title="Bar-Chart",subtitle=titel,x="Anzahl",y=achse)+
        ggplot2::theme(legend.position = "none")
    }
    gridExtra::grid.arrange(p.bar,nrow=1,ncol=1)
  }
  return(var.gesamt)
}
