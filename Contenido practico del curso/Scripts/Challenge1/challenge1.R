devtools::install_github("mattflor/chorddiag")
library(chorddiag)
library(ggplot2)
## Lectura de datos
datos <- scan("gen.txt", what = character())
splitdatos <- strsplit(datos, split = character())
# Longitud de caracteres y numero de bases.
cont <- 0
contA <- 0
contT <- 0
contG <- 0
contC <- 0
j <- as.numeric(length(datos))
for (i in 1:j) {
cont <- cont + nchar(datos[i])
contA <- contA + sum(splitdatos[[i]] == "A")
contT <- contT + sum(splitdatos[[i]] == "T")
contG <- contG + sum(splitdatos[[i]] == "G")
contC <- contC + sum(splitdatos[[i]] == "C")
}
Bases <- c("A", "T", "G", "C")
Frecuencias <- c(contA, contT, contG, contC)
datosbase <- data.frame(Bases,Frecuencias)
#Gráfico de frecuencias.
ggplot(datosbase) + geom_col(aes(x = Bases, y = Frecuencias,
                                 fill = Bases), colour = "gray15", alpha=0.75)+
  ylab("Porcentaje") + geom_text( aes(x = Bases,y = Frecuencias*0.85,
                                      label = Frecuencias) )+
  labs(fill="Bases")+
  scale_fill_brewer(palette = "Spectral",type = "div", name="Base") + theme_bw()

# Probabilidad condicional

tabla_conteo <- matrix(0, nrow = 4, ncol = 4)
row.names(tabla_conteo) <- Bases
colnames(tabla_conteo) <- Bases
ant_s <- "A"

for (i in 1:8319) {
  for (j in 1:70) {
    if (i==1 & j ==1) {
      next
    }
    s <- splitdatos[[i]][j]
    
    if (ant_s == "A") {
      ant_s <- 1
    } else if (ant_s =="T") {
      ant_s <- 2
    } else if (ant_s =="G") {
      ant_s <- 3
    } else if (ant_s =="C") {
      ant_s <- 4
    }
    
    if (s == "A") {
      s <- 1
    } else if (s =="T") {
      s <- 2
    } else if (s =="G") {
      s <- 3
    } else if (s =="C") {
      s <- 4
    }
    
    tabla_conteo[ant_s,s] <- (tabla_conteo[ant_s,s]+1)
    ant_s <- splitdatos[[i]][j]
  }
  
}
  for (i in 1:4) {
  tabla_conteo[i,] <- tabla_conteo[i,]/datosbase[i,2]
}
#Diagrama chord

groupColors <- c("#D7191C", "#FDAE61", "#ABDDA4", "#2B83BA")
dimnames(tabla_conteo) <- list(From = c("A", "C", "G", "T"), To =c("A", "C", "G", "T"))
p <- chorddiag(t(tabla_conteo), groupColors = groupColors, groupnamePadding = 30, 
               tickInterval = 0.05, type = "bipartite")


