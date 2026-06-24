library(wakefield)

set.seed(1990)

fake = tibble(person = 1:300, 
       drafted = sample(x = c(TRUE, FALSE), size = 300, replace = TRUE),
       completed_highschool = rbinom(n = 300, size = 1, prob = .5 + .2 * drafted),
       criminal_conviction =  rbinom(n = 300, size = 1, prob = .5 - .3 * drafted),
       gpa = runif(n = 300, min = 2.5, max = 4),
       married = rbinom(n = 300, size = 1, prob = .5)
       )


fake |> 
  group_by(drafted) |> 
  summarise(across(everything(), mean))

write_rds(fake, file = "data/draft-study.rds")
