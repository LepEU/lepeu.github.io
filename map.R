# Title: R Script to Map Coordinator and Institution Locations
# Description: This script reads two CSV files, geocodes institution locations,
#              and plots them on a map along with coordinator locations.

# --- 1. Install and Load Required Packages ---
# You may need to install these packages if you haven't already.
# You can do this by running the following lines (uncomment them):
# install.packages("readr")
# install.packages("dplyr")
# install.packages("tidygeocoder")
# install.packages("ggplot2")
# install.packages("maps")

# Load the libraries into your R session
library(readr)
library(dplyr)
library(tidygeocoder)
library(ggplot2)
library(maps)
library(cowplot) # Load cowplot for combining plots
library(ggspatial) # Load ggspatial for map elements

# --- 2. Load the Datasets ---
# Load the regional coordinators data which already contains lat/long
coordinators <- read_csv("~/Downloads/RegionalCollectionCoordinators.csv")

# Load the working group members' institutions
institutions_raw <- read_csv("~/Downloads/10KLepGenomes WG4 members- WG4 Members Institutions.csv")
# 
# # --- 3. Geocode Institution Locations ---
# # Geocoding turns addresses/place names into geographic coordinates.
# 
# # First, get a list of unique institution names to avoid geocoding the same place multiple times.
# unique_institutions <- institutions_raw %>%
#    distinct(affiliation, country)
# # 
# # # Use the geocode() function to find latitude and longitude for each institution.
# # # This uses the free OpenStreetMap (OSM) Nominatim service.
# # # Note: This step requires an internet connection and may take a moment.
#  geocoded_institutions <- unique_institutions %>%
#    geocode(address = affiliation, method = 'osm', lat = latitude, long = longitude)
# # 
# # # Report on the geocoding results
#  cat("Geocoding complete.\n")
#  cat(sum(!is.na(geocoded_institutions$latitude)), "out of", nrow(geocoded_institutions), "unique institutions were successfully geocoded.\n")
# # 
# # # Filter out any institutions that could not be geocoded to prevent errors during plotting
# geocoded_institutions_clean <- geocoded_institutions %>%
#    filter(!is.na(latitude) & !is.na(longitude))
#write.csv(geocoded_institutions, "~/Downloads/gecoded_institutions.csv", quote = F, row.names = F)

geocoded_institutions_clean <- read.csv("~/Downloads/gecoded_institutions.csv")

# --- 4. Create the Map ---
# Get base map data for the world
world_map <- map_data("world")

# Define the bounding box for the main map's focused region
bbox <- data.frame(
  xmin = -12,
  xmax = 38,
  ymin = 30,
  ymax = 70
)

# Create the map using ggplot2
# We start with a base map and then add layers of points on top.
map_plot <- ggplot() +
  # Draw the world map polygons
  geom_polygon(data = world_map, aes(x = long, y = lat, group = group), fill = "lightyellow", color = "gray75") +
  
  # Add the geocoded institution locations as smaller blue points
  geom_point(data = geocoded_institutions_clean, aes(x = longitude, y = latitude),
             color = "black", alpha = 0.7, size = 2, shape = 19) +
  
  # Add the regional coordinator locations as butterfly symbols
  # Note: Your plotting device must support UTF-8 characters for the butterfly to render.
  geom_point(data = coordinators, aes(x = long, y = lat), 
            shape = 21, fill = "tomato3", size = 8, linewidth=2, alpha=0.8) +
  #add two letter codes for regional collecters
  geom_text(data = coordinators, aes(x = long, y = lat, label=CountryCode), 
             color = "white", size = 3, fontface=2) +
  
  # Set the map's coordinate limits to focus on Europe and surrounding areas
  # Set the map's coordinate limits to focus on Europe and surrounding areas
  coord_sf(xlim = c(bbox$xmin, bbox$xmax), ylim = c(bbox$ymin, bbox$ymax), 
           expand = FALSE) + #, crs = "+proj=ortho +lat_0=50 +lon_0=10"
  
  
  # Add titles and labels
  # labs(
  #   title = "Map of WG4 Member Institutions and Regional Coordinators",
  #   subtitle = "Institutions (blue dots) and Coordinators (butterflies)",
  #   x = "Longitude",
  #   y = "Latitude"
  # ) +
  # Add a scale bar to the main map
  # annotation_scale(location = "bl", plot_unit = "km") +
  # # Add a north arrow to the main map
  # annotation_north_arrow(
  #   location = "bl", which_north = "true",
  #   pad_x = unit(0.1, "in"), pad_y = unit(0.2, "in"),
  #   style = north_arrow_fancy_orienteering
  # ) +
  # Use a clean, minimal theme for the map
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
    plot.subtitle = element_text(hjust = 0.5, size = 12),
    panel.grid.major = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    panel.background = element_rect(fill = "lightskyblue1")
  )
   
inset_map <- ggplot() +
  geom_polygon(data = world_map, aes(x = long, y = lat, group = group), fill = "lightyellow", color = "gray80", linewidth = 0.1) +
  # Add the rectangle showing the main map's view
  geom_rect(data = bbox, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
            color = "#D55E00", fill = "transparent", linewidth = 0.8) +
  coord_sf(expand = FALSE) +
  # Use a theme with no labels, titles, or gridlines for the inset
  theme_void() +
  theme(
    panel.background = element_rect(fill = "lightskyblue1", color = "black", linewidth=0.5) # Ocean color and border
  )

# --- 5. Combine the Main Map and Inset Map ---
# Use cowplot to draw the main map and then overlay the inset map
final_plot <- ggdraw() +
  draw_plot(map_plot) +
  draw_plot(inset_map, x = 0.095, y = 0.775, width = 0.25, height = 0.25)


# --- 6. Display the Final Combined Map ---
# Print the final plot to the viewer
print(final_plot)

# --- 7. Save the Plot to Files ---
# Save the final plot as a high-resolution PNG file
ggsave("map_plotwithccodes.png", plot = final_plot, width = 9, height = 6, units = "in", dpi = 400)

# Save the final plot as a vector SVG file
ggsave("map_plot.svg", plot = final_plot, width = 12, height = 9, units = "in")

###########with country nmaes=#####################################
library(sf)
library(rnaturalearth)
# Get base map data with country information using the rnaturalearth package
# This returns an 'sf' (simple features) object that works well with ggplot2
world <- ne_countries(scale = "medium", returnclass = "sf")
map_plot <- ggplot(data = world) +
  # Draw the country polygons from the sf object
  geom_sf(fill = "lightyellow", color = "gray80") +
  
  # Add the country names in English.
  # We use st_point_on_surface to ensure labels are placed inside their respective polygons.
  geom_sf_text(aes(label = name_en), 
               size = 3, 
               color = "gray40", 
               fun.geometry = st_point_on_surface, 
               check_overlap = TRUE) + # This helps to reduce label clutter
  
  # Add the geocoded institution locations as smaller blue points
  geom_point(data = geocoded_institutions_clean, aes(x = longitude, y = latitude),
             color = "black", alpha = 0.7, size = 2, shape = 19) +
  
  # Add the regional coordinator locations as butterfly symbols
  # Note: Your plotting device must support UTF-8 characters for the butterfly to render.
  geom_point(data = coordinators, aes(x = long, y = lat), 
             shape = 21, fill = "gold", size = 8, linewidth=2) +
  
  # Set the map's coordinate limits to focus on Europe and surrounding areas
  coord_sf(xlim = c(bbox$xmin, bbox$xmax), ylim = c(bbox$ymin, bbox$ymax), 
           expand = FALSE) +
  
  # Add titles and labels
  # labs(
  #   title = "Map of WG4 Member Institutions and Regional Coordinators",
  #   subtitle = "Institutions (blue dots) and Coordinators (butterflies)",
  #   x = "Longitude",
  #   y = "Latitude"
  # ) +
  
  # Use a clean, minimal theme for the map and set the ocean color
  theme_void() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
    plot.subtitle = element_text(hjust = 0.5, size = 12),
    panel.background = element_rect(fill = "lightskyblue1", color = NA) # Set ocean color
  )

# --- 5. Display the Map ---
# Print the final map plot to the viewer

print(map_plot)
