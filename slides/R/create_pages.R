# libraries
library(tidyverse)


# read in schedule
df = read_csv("data/schedule.csv")


# text to write 
text_content = '---
title: "Hello"
---


```{r slides, echo=FALSE, include=FALSE}
source(here::here("R", "slide-things.R"))

slide_details = tibble::tribble(
  ~youtube_id,   ~title, ~slide, ~active,
  "", "", "1", TRUE)

```

## Recommended

- {{< fa book >}}
- {{< fa book >}}


## Slides



```{r show-slide-tabs, echo=FALSE, results="asis"}
slide_buttons("/static/slides/02-viz")
slide_tabs(slide_details, "/static/slides/02-viz.html")
```

::: {.callout-note}
You can navigate through the slides with <kbd>←</kbd> and <kbd>→</kbd>. If you type <kbd>F</kbd> you can go full-screen. 
:::


'

# assignment text
text_assignment = '---
title: "Hello"
---

## Instructions


1. Download this: <i class="far fa-file-archive"></i> [`FILE NAME`](/file_path.Rmd)
    - right-click, "save/download file as..."
2. Complete all of the coding tasks in the `.Rmd` file
3. **Once you are done**, go on Canvas and answer the questions related to the assignment
4. You will submit your `.Rmd` file in the Canvas assignment

## Tips

- Make sure you: 
    - run all of the code chunks that already have code in them
    - write your code in the empty code chunks
- Useful shortcuts: 
    - to run all the code in a specific code chunk, press the green right-facing triangle at the top right of the code chunk
    - to run all *prior* code chunks, press the downward-facing gray triangle at the top right of the code chunk

'


# example text 
text_example = '---
title: "Hello"
---



```{r setup, include=FALSE}
# set knit options
knitr::opts_chunk$set(
  fig.width=9, 
  fig.height=5, 
  fig.retina=3,
  fig.align="center",
  out.width = "100%",
  cache = FALSE,
  echo = FALSE,
  message = FALSE, 
  warning = FALSE
)

# source in functions
source(here::here("R", "funcs.R"))

```




# In-class example


'

# create the qmds
df |> 
  select(content) |> 
  drop_na() |> 
  mutate(content = str_remove(content, "^/"),
         content = paste0(content, ".qmd")) |> 
  pull() |> 
  map( .f = ~ writeLines(text = text_content, con = .x))


# create the qmds
df |> 
  select(assignment) |> 
  drop_na() |> 
  mutate(assignment = str_remove(assignment, "^/"),
         assignment = paste0(assignment, ".qmd")) |> 
  pull() |> 
  map( .f = ~ writeLines(text = text_assignment, con = .x))


df |> 
  select(example) |> 
  drop_na() |> 
  mutate(example = str_remove(example, "^/"),
         example = paste0(example, ".qmd")) |> 
  pull() |> 
  map( .f = ~ writeLines(text = text_example, con = .x))

