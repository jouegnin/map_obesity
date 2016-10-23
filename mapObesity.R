 library(ggplot2)
 library(dplyr)
 library(rvest)
 library(scales)
 library(maps)
 library(mapproj)
 library(XML)

# Read the html code and get the data from the page

obesity<- read_html("https://en.wikipedia.org/wiki/Obesity_in_the_United_States")
obesity<- obesity%>%
            html_nodes("table")%>%
            .[[1]]%>%
            html_table(fill=T)
            
# Clean the data

## Remove the % symbol and make the numbers numeric data
for(i in 2:4){
  obesity[,i] = gsub("%","", obesity[,i])
  obesity[,i] = as.numeric(obesity[,i])
}

# Change the names syntax using make.names()
names(obesity)<- make.names(names(obesity))

# Load the Map data
states<- map_data("state")

# Create a new variable name for the state in the obesity table
obesity$region<- tolower(obesity$State.and.District.of.Columbia)

# Merge both datasets
states<- merge(states, obesity, by = "region", all.x = T)

# Plot the data

## Adult Plot
ggplot(data = states, aes(x = long, y = lat, group = group, fill = Obese.adults))+
  geom_polygon(color = "white")+
  scale_fill_gradient(name = "Percent", low = "#fecada", high = "red", guide = "colorbar",
                      na.value = "black", breaks = pretty_breaks(n = 5))+
  labs(title = "Prevalance of Obesity in Adults")+
  coord_map()
  
## Children Plot
ggplot(data = states, aes(x = long, y = lat, group = group, fill = Obese.children.and.adolescents))+
  geom_polygon(color = "white")+
  scale_fill_gradient(name = "Percent", low = "#fecada", high = "#0D045E", guide = "colorbar",
                      na.value = "black", breaks = pretty_breaks(n = 5))+
  labs(title = "Prevalance of Obesity in Children and Adolescents")+
  coord_map()






