# libraries
library(tidyverse)
library(calendar)

# set the hard dates
start_day = "2024-09-25"
end_day = "2024-12-06"
final = "2024-12-10 10:30 AM"
midterm = "2024-10-28 8:00 AM"
breaks = c("2024-11-11", "2024-11-27")
meets_on = c("Mon", "Wed")
class_time = "8:00:00"
meeting_room = "Young Hall 198"

# create class schedule

## all days between start and end
schedule = tibble(dates = seq(from = ymd(start_day), 
                              to = ymd(end_day),
                              by = "days"),
       day = wday(dates, label = TRUE)) |> 
  # filter to meeting days
  filter(day %in% meets_on) |> 
  # filter out breaks
  filter(!dates %in% ymd(breaks)) |> 
  # add weeks
  mutate(week = isoweek(dates), 
         week = week - (min(week) - 1), 
         week = str_pad(week, width = 2, pad = "0")) |> 
  mutate(dates = ymd_hms(paste(dates, class_time)))


# set homework weeks
homework_on = tibble(week = c(2, 3, 4, 6, 7, 8, 9, 10)) |> 
  mutate(week = paste0("Week ", str_pad(week, width = 2, pad = "0")))

# create condensed version so each row is a week

## pivot wider
schedule = schedule |> 
  mutate(week = paste0("Week ", week)) |> 
  pivot_wider(names_from = day, values_from = dates) |> 
  # add all the extras
  mutate(content = paste0("/content/", str_extract(week, "\\d+"), "-content"),
         assignment = ifelse(week %in% homework_on$week, 
                             paste0("/assignment/", str_extract(week, "\\d+"), "-assignment"),
                             NA),
         example = paste0("/example/", str_extract(week, "\\d+"), "-example")) |> 
  select(week, date = 3, day2 = 2, content, assignment, example)


# set homework weeks
homework_on = tibble(week = c(2, 3, 4, 6, 7, 8, 9, 10)) |> 
  mutate(week = paste0("Week ", str_pad(week, width = 2, pad = "0")))

# merge in topics
topics = tribble(~week, ~title,
        "Week 01", "Hello",
        "Week 02", "Data visualization",
        "Week 03", "Data wrangling",
        "Week 04", "Relationships",
        "Week 05", "Modeling",
        "Week 06", "Prediction",
        "Week 07", "Causality",
        "Week 08", "DAGs",
        "Week 09", "Natural experiments",
        "Week 10", "Uncertainty",
        "Week 11", "Hypothesis testing")


# finish up
schedule = schedule |> 
  left_join(topics, by = "week") |> 
  # add in exams
  add_row(week = "", 
          title = glue::glue('Final exam, in class {hms::as_hms(ymd_hm(final))} <i class="fa-solid fa-star"></i>'), date = ymd_hm(final)) |> 
  add_row(week = "", 
          title = 'Midterm exam, in class <i class="fa-solid fa-star"></i>', date = ymd_hm(midterm), .after = 5)

write_csv(schedule, "data/schedule.csv")



# make ical
schedule_long = schedule |> 
  # make schedule long
  pivot_longer(cols = c(date, day2), names_to = "type", values_to = "value") |> 
  select(title, value) |> 
  drop_na() |> 
  mutate(title = paste0("POL51F24: ", title))

dtstamp <- ic_char_datetime(now("UTC"), zulu = TRUE)

ical = schedule_long |>
  mutate(id = row_number()) |>
  group_by(id) |>
  nest() |>
  mutate(ical = map(data,
                    ~ic_event(start = .$value[[1]],
                              end = .$value[[1]] + 90*60,
                              summary = .$title[[1]],
                              more_properties = TRUE,
                              event_properties = c("DTSTAMP" = dtstamp,
                                                   "LOCATION" = meeting_room)))) |>
  ungroup() |>
  select(-id, -data) |>
  unnest(ical) |> 
  ical()


calendar::ic_write(ical, "data/schedule.ics")         
