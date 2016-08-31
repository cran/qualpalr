## ----basic_usage---------------------------------------------------------
library(qualpalr)
set.seed(1) # The optimizer uses random initial parameters
pal <- qualpal(n = 5, list(h = c(0, 360), s = c(0.4, 0.6), l = c(0.5, 0.85)))
pal <- qualpal(n = 4, colorspace = "pretty")

## ----qualpal_list--------------------------------------------------------
pal

## ----fig.show='hold'-----------------------------------------------------
# Multidimensional scaling plot
plot(pal)

# Pairs plot in the Lab color space
pairs(pal, colorspace = "Lab")


## ----map, fig.width = 5, fig.height = 5----------------------------------
library(maps)
map("france", fill = TRUE, col = pal$hex, mar = c(0, 0, 0, 0))

