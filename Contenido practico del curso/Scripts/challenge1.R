library(ggplot2)
## Lectura de datos
datos <- scan("gen.txt", what = character())
splitdatos <- strsplit(datos, split = character())
prueba <- unlist(splitdatos)
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
#Gráfico de frecuencias.
Bases <- c("A", "T", "G", "C")
Frecuencias <- c(contA, contT, contG, contC)
datosbase <- data.frame(Bases,Frecuencias)
ggplot(data = datosbase) +
  geom_bar(mapping = aes(x = Bases, y = Frecuencias, fill = Bases), stat = "identity")+
  labs(title = "Frecuencia de las bases en la muestra del gen")+
  scale_y_continuous(limits = c(0,250000))

#
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
tabla_conteo <- tabla_conteo/(cont-1)



