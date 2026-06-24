# libraries
library(tidyverse)
library(ggrepel)
library(here)
library(kableExtra)
library(janitor)
library(patchwork)

# custom colors

# dubois colors
red = "#dc354a"
yellow = "#ecb025"
blue = "#213772"
full = "#5e81ac"

# custom ggplot theme
theme_nice = function() {
  theme_minimal(base_family = "Fira Sans", base_size = 14) +
    theme(panel.grid.minor = element_blank(),
          plot.background = element_rect(fill = "white", color = NA),
          plot.title = element_text(family = "Fira Sans ExtraBold"),
          axis.title = element_text(family = "Fira Sans Medium"),
          strip.text = element_text(family = "Fira Sans Bold", size = rel(0.8), hjust = 0),
          strip.background = element_rect(fill = "grey80", color = NA))
}

theme_set(theme_nice())

palette = MetBrewer::met.brewer(name = "Cross")



# label fonts
update_geom_defaults("label", list(family = "Fira Sans"))
update_geom_defaults("label_repel", list(family = "Fira Sans"))