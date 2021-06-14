library(readr)
library(foreign)
library(dplyr)
library(tidyr)
library(magrittr)

# base que enlista los municipios de mexico y las 30 estaciones más cercanas a cada municipio
filename <- "RUTAARCHIVOQGIS/dist_mun_stations.dbf"

dist_mat <- read.dbf(filename)

summary(dist_mat)

# convertir distancia a km
dist_mat$dist <- (dist_mat$Distance/1000) %>% round(2)

# crear la distancia inversa
dist_mat$inv_dist <- 1/dist_mat$dist

# restringir estaciones dentro de un radio de 320km
distw <- dist_mat %>% filter(dist<=320) %>%
  select(-c(dist,Distance))


names(distw)[2] <- "STATION"
distw$STATION <- distw$STATION %>% as.character()

summary(distw)

# lista de estaciones como título de los archivos csv
estaciones <- distw$STATION %>% unique()  %>% paste0(".csv")

# guardo la lista de las estaciones
write_csv(as.data.frame(estaciones), "estaciones_final.csv", col_names = TRUE)

# funcion que va al csv, calcula la temperatura promedio y formatea la base
# a una columna por dia del año
infocsv <- function(file){
  
  p <- NULL
  w <- NULL
  
  p <- read_csv(file,
                col_names = TRUE,
                col_types = cols_only(
                  STATION = col_character(),
                  DATE = col_date(),
                  MAX = col_double(),
                  MIN = col_double()
                ))

  p$MAX[p$MAX>500] <- NA
  p$MIN[p$MIN>500] <- NA
  
  w <- p %>% mutate(mean = (MAX+MIN)/2) %>%
    select(-c(MAX,MIN)) %>% 
    pivot_wider(id_cols = "STATION", names_from = "DATE",values_from = mean)
}

library(plyr)

# se aplica la funcion a todas las bases de clima que están cerca de mexico
temps <- estaciones %>% lapply(infocsv) %>% do.call(rbind.fill,.) %>%
  as.data.frame()

detach(package:plyr)

# unir base de temperatura con base de municipios
distw <- left_join(distw,temps,by="STATION")

# mantener estaciones que tengan menos de 65 NAs
distw <- distw[apply(distw, 1, function(x) sum(is.na(x)))<65,]

# número de estaciones por municipio
distw <- add_count(distw, InputID, name = "n")
summary(distw$n)

# creo la variable weight con las distancias inversas
distw <- distw %>% group_by(InputID) %>%
  mutate(weight = inv_dist/sum(inv_dist))

# multiplico el weight por cada temperatura
distw[,-c(1:2,369:370)] <- distw[["weight"]] * distw[,-c(1:2,369:370)]

# base final
temp_data <- aggregate( distw[,-c(1:3,369:370)], distw[,1], 
                        FUN = sum, na.rm=TRUE, na.action=NULL)

summary(temp_data)

setwd( "DIRECTORIO/proyecto2")
write_csv(temp_data,"temp_data.csv", col_names = TRUE)
