library(sf)
library(dplyr)
library(raster)

# Tiling the study area

# get study area
sa <- raster::getData('GADM', country='ARG', level=0, download = TRUE, path = "data/")

# reproject to a CRS, e.g. EPSG:5346 POSGAR 2007 (Argentina)
inpoly <- sa %>% 
  st_as_sf() %>% 
  sf::st_transform(5346) %>% 
    st_geometry()

# define the meters of the tiles
x = 100000
# tiling the area
grd <- sf::st_make_grid(inpoly, cellsize = x) %>% st_as_sf()
plot(inpoly, col = "blue")
plot(grd, add = TRUE)

# filter the tiles outside the study area
tiles <- st_filter(grd, inpoly)
tiles$id <- 1:length(tiles$x)

plot(inpoly, col = "blue")
plot(tiles, add = TRUE)

st_write(tiles, "data/tiles_100km.shp")
