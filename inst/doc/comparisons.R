## ----functions, echo = FALSE--------------------------------------------------
plot_analysis <- function(pal, metric = "ciede2000", cvd = "normal", ...) {
  pal_result <- analyze_palette(pal, metric = metric)[[cvd]][["min_distances"]]
  colors <- names(pal_result)
  res <- as.numeric(pal_result)

  opar <- par(no.readonly = TRUE)
  par(mar = c(5.1, 4.1, 3, 0.1))

  barplot(
    res,
    names.arg = colors,
    col = pal,
    ylim = c(0, 50),
    las = 2,
    ylab = "Color difference (CIEDE2000)",
    ...
  )

  par(opar)
}

## -----------------------------------------------------------------------------
library(qualpalr)

hcl_space <- list(h = c(50, 290), c = c(0, 134), l = c(25, 85))
pal <- qualpal(n = 5, hcl_space)

pal

## -----------------------------------------------------------------------------
iwanthue <- c(
  "#5f683c",
  "#5c87b5",
  "#79bf4b",
  "#c79041",
  "#7bb99d"
)

analyze_palette(pal$hex, metric = "ciede2000")$normal
analyze_palette(iwanthue, metric = "ciede2000")$normal

## ----plot-iwanthue, echo = FALSE----------------------------------------------
plot_analysis(pal$hex, main = "Qualpal")
plot_analysis(iwanthue, main = "iWantHue")

## -----------------------------------------------------------------------------
colorgorical <- c("#b4ddd4", "#9b233d", "#2eece6", "#f82387", "#32a190")

## ----plot-colorgorical, echo = FALSE------------------------------------------
plot_analysis(pal$hex, main = "Qualpal")
plot_analysis(colorgorical, main = "Colorgorical")

## -----------------------------------------------------------------------------
glasbey <- c(
  "#b20000",
  "#caa200",
  "#ff8ab2",
  "#aa145d",
  "#9e5d00",
  "#ff7910",
  "#ff008a",
  "#ca5d55"
)

pal2 <- qualpal(8, list(h = c(-90, 90), c = c(50, 100), l = c(30, 70)))

## ----plot-glasbey, echo = FALSE-----------------------------------------------
plot_analysis(pal2$hex, main = "Qualpal")
plot_analysis(glasbey, main = "Glasbey")

## -----------------------------------------------------------------------------
glasbey_extend <- c(
  "#2a3e63",
  "#7088b8",
  "#fcaf3e",
  "#b87088",
  "#417108",
  "#45dfa6",
  "#6d0c49",
  "#dfaaff"
)

base_pal <- c(
  "#2a3e63",
  "#7088b8",
  "#fcaf3e",
  "#b87088"
)

pal_extend <- qualpal(
  8,
  list(h = c(50, 280), c = c(50, 80), l = c(25, 70)),
  extend = base_pal
)

## ----plot-glasbey-extend, echo = FALSE----------------------------------------
plot_analysis(pal_extend$hex, main = "Qualpal (extended)")
plot_analysis(glasbey_extend, main = "Glasbey (extended)")

## -----------------------------------------------------------------------------
glasbey_cvd <- c(
  "#512deb",
  "#317d00",
  "#92d200",
  "#39ceff",
  "#00ba92",
  "#0082b2"
)

cvd_pal <- qualpal(
  6,
  list(h = c(50, 280), c = c(50, 80), l = c(25, 70)),
  cvd = c(protan = 1)
)

## ----plot-glasbey-cvd, echo = FALSE-------------------------------------------
plot_analysis(cvd_pal$hex, main = "Qualpal (CVD)", cvd = "protan")
plot_analysis(glasbey_cvd, main = "Glasbey (CVD)", cvd = "protan")

## -----------------------------------------------------------------------------
distinctipy <- c(
  "#cf02fd",
  "#00ff00",
  "#ff8000",
  "#01aced",
  "#0905c3",
  "#538337",
  "#80ff80",
  "#a80549",
  "#b28cd2"
)

pal3 <- qualpal(9, list(h = c(0, 360), s = c(0, 1), l = c(0, 1)))

## ----plot-distinctipy, echo = FALSE-------------------------------------------
plot_analysis(pal3$hex, main = "Qualpal")
plot_analysis(distinctipy, main = "Distinctipy")

## -----------------------------------------------------------------------------
palettailor <- c(
  "#4ca600",
  "#5dfbbf",
  "#eda59f",
  "#32998d",
  "#605ec4",
  "#0099ef",
  "#e950e8",
  "#e1f32e",
  "#936411",
  "#e9003e"
)

hsl_space <- list(h = c(0, 360), s = c(0, 1), l = c(0.45, 0.95))
pal3 <- qualpal(10, hsl_space, bg = "white")

## ----plot-palettailor, echo = FALSE-------------------------------------------
plot_analysis(pal3$hex, main = "Qualpal")
plot_analysis(palettailor, main = "Palettailor")

