setwd("~/git/geoScripting/Lesson7_excercise")
getwd()
library(raster)
## Download, unzip and load the data
download.file(url = 'https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip', destfile = 'data/modisndvi.zip', method = 'auto')
unzip('data/modisndvi.zip', exdir = "data")
# Identify the right file

modisPath <- list.files(path="data", pattern = glob2rx('*.grd'), full.names = TRUE)
modisPath
nlModis <- stack(modisPath)


nlMunicipality <- getData('GADM',country='NLD', level=2,path = "data")
class(nlMunicipality)
# Investigate the structure of the object
head(nlMunicipality@data)

# Load rgdal library (needed to reproject data)
library(rgdal)
nlMunicipalityUTM<- spTransform(nlMunicipality, CRS(proj4string(nlModis)))
nlMunicipalityExtractOveryear <- extract(nlModis, nlMunicipalityUTM, fun = mean,sp= TRUE)


str(nlMunicipalityExtractOveryear@data)
df <- nlMunicipalityExtractOveryear@data
df
#the greenest MunicipalityIn January
InJan <- df$NAME_2[which(df$January == max(df$January, na.rm = TRUE))] 

#the greenest Municipality In  August
InAug <-df$NAME_2[which(df$August == max(df$August, na.rm = TRUE))] 

#the greenest Municipality On average over the year
df$RM <- rowMeans(subset(df, select = c(January: December)), na.rm = TRUE)
str(df)
 OverYear <- df$NAME_2[which(df$RM == max(df$RM, na.rm = TRUE))]
 

 municipalityContour <- nlMunicipalityUTM[nlMunicipalityUTM$NAME_2 == InJan,]  
 municipalityContourcrop <- crop(nlModis$January, municipalityContour)
 
 
 
 plot(municipalityContourcrop, main = InJan)

 plot(municipalityContour, add = TRUE)
 
 
 plot(municipalityContour, lwd = 2, border = "red", add=T)
 
 grid()
 box()
 mtext(side = 3, line = 1, "NDVI in January", cex = 0.7)
mtext(side = 1, "Longitude", line = 2.5, cex=1.1)
mtext(side = 2, "Latitude", line = 2.5, cex=1.1)
 