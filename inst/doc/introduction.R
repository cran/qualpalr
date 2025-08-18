## -----------------------------------------------------------------------------
library(qualpalr)
pal <- qualpal(5, list(h = c(-200, 120), s = c(0.3, 0.8), l = c(0.4, 0.9)))

# Adapt the color space to deuteranopia of severity 0.7
pal <- qualpal(5, cvd = c(deutan = 0.7))

## -----------------------------------------------------------------------------
pal

## -----------------------------------------------------------------------------
# Multidimensional scaling plot
plot(pal)

# Pairs plot in the DIN99d color space
pairs(pal, colorspace = "DIN99d")

## ----map----------------------------------------------------------------------
library(maps)
map("france", fill = TRUE, col = pal$hex, mar = c(0, 0, 0, 0))

## -----------------------------------------------------------------------------
options(rgl.useNULL = TRUE)
library(rgl)

# Set up color subspace as in qualpal()
h <- c(-200, 120)
s <- c(0.3, 0.8)
l <- c(0.4, 0.9)

# Generate a quasi-random Halton sequence
rnd <- randtoolbox::halton(1000, dim = 3)

# Convert random sequence to specified color space
scale_runif <- function(x, new_min, new_max) {
  (new_max - new_min) * (x - 1) + new_max
}

rnd[, 2] <- sqrt(rnd[, 2])
H <- scale_runif(rnd[, 1], min(h), max(h))
S <- scale_runif(rnd[, 2], min(s), max(s))
L <- scale_runif(rnd[, 3], min(l), max(l))

HSL <- cbind(H, S, L)
HSL[HSL[, 1] < 0, 1] <- HSL[HSL[, 1] < 0, 1] + 360

# Set up variables to produce the HSL cylinder
x <- S * cos(H * pi / 180)
y <- S * sin(H * pi / 180)

# Convert to RGB to enable coloring
RGB <- qualpalr:::convert_colors(HSL, "hsl", "rgb")

plot3d(cbind(x, y, L), col = rgb(RGB), main = "HSL")
rglwidget()

## -----------------------------------------------------------------------------
plot3d(RGB, col = rgb(RGB), main = "RGB")
rglwidget()

## -----------------------------------------------------------------------------
DIN99d <- qualpalr:::convert_colors(RGB, "rgb", "din99d")

plot3d(DIN99d, col = rgb(RGB), main = "DIN99d")
rglwidget()

## -----------------------------------------------------------------------------
pal <- qualpal(5, list(h = c(-200, 120), s = c(0.3, 0.8), l = c(0.4, 0.9)))
plot3d(DIN99d, col = rgb(RGB), main = "DIN99d", alpha = 0.1)
plot3d(pal$DIN99d, col = pal$hex, main = "DIN99d", add = TRUE, size = 5)
rglwidget()

