### loading libraries here
library(tidyverse)
#####

dir.create("data")
dir.create("data_output")
dir.create("fig_output")

download.file("https://raw.githubusercontent.com/rltillett/r-socialsci/gh-pages/files/SAFI_clean.csv",
              "data/SAFI_clean.csv", mode = "wb")
area_hectares <- 1.0    # doesn't print anything
(area_hectares <- 1.0)  # putting parenthesis around the call prints the value of `area_hectares`
area_hectares         # and so does typing the name of the object

##################
# lines can start with comments too
##################

area_hectares <- 2.5
area_hectares <- 50
2.47 * area_hectares
area_acres <- 2.47 * area_hectares

no_membrs <- c(3, 7, 10, 6)
no_membrs

respondent_wall_type <- c("muddaub", "burntbricks", "sunbricks")
respondent_wall_types

possessions <- c("bicycle", "radio", "television")
possessions <- c(possessions, "mobile_phone") # add to the end of the vector
possessions <- c("car", possessions) # add to the beginning of the vector
possessions

### load downloaded csv into "interviews" data frame
interviews <- read_csv("data/SAFI_clean.csv", na = "NULL")

select(interviews, village, no_membrs, years_liv)

filter(interviews, village == "God")

# this below is the old and bad way of sub-setting data
# first, grab the rows and shove them in a new data frame
interviews2 <- filter(interviews, village == "God")
interviews_complicated <- select(interviews2, no_membrs, years_liv)

# better tidy pipe way
interviews %>%
  filter(village == "God") %>%
  select(no_membrs, years_liv)
# and save the output to a new small dataframe
new_df <- interviews %>%
  filter(village == "God") %>%
  select(no_membrs, years_liv)

# if you really wanted to, you could write it like this too:
interviews %>%
  filter(village == "God") %>%
  select(no_membrs, years_liv) ->
  new_df_name

# select/filter Exercise in Section 4
interviews %>% 
  filter(memb_assoc == "yes") %>%  
  select(affect_conflicts, liv_count, no_meals)

# mutate exampe 1
interviews %>%
  filter(!is.na(memb_assoc)) %>%
  mutate(people_per_room = no_membrs / rooms)

# exercise 2 from secion 4
# Create a new data frame 
#from the interviews data 
#that meets the following criteria: contains only the village column and a new column called total_meals 
# containing a value that is equal to the total number of meals served in the household per day on average (no_membrs times no_meals). Only the rows where total_meals is greater than 20 should be shown in the final data frame.

totalmeal_set <- interviews %>%
  mutate(total_meals = no_membrs * no_meals) %>%
  select(village, total_meals)  %>% 
  filter(total_meals > 20)

### summarize and group-by
interviews %>%
  filter(!is.na(memb_assoc)) %>%
  group_by(village, memb_assoc) %>%
  summarize(mean_no_membrs = mean(no_membrs), min_membrs = min(no_membrs)) %>% 
  arrange(desc(min_membrs))

## counting number of elements
interviews %>%
  count(village, sort = TRUE)

# spread commands not super clear as to how they work
interviews_spread <- interviews %>%
  mutate(wall_type_logical = TRUE) %>%
  spread(key = respondent_wall_type, value = wall_type_logical, fill = FALSE)

# gathering
interviews_gather <- interviews_spread %>%
  gather(key = respondent_wall_type, value = "wall_type_logical",
         burntbricks:sunbricks) %>% 
  filter(wall_type_logical == TRUE) %>% 
  select(-wall_type_logical) # cool, minus notation for "select all but this"

## mutating to work on items owned in ggplot later
interviews_plotting <- interviews %>%
  ## spread data by items_owned
  mutate(split_items = strsplit(items_owned, ";")) %>% 
  unnest() %>%
  mutate(items_owned_logical = TRUE) %>%
  spread(key = split_items, value = items_owned_logical, fill = FALSE) %>%
  rename(no_listed_items = `<NA>`) %>%
  mutate(split_months = strsplit(months_lack_food, ";")) %>%
  unnest() %>%
  mutate(months_lack_food_logical = TRUE) %>%
  spread(key = split_months, value = months_lack_food_logical, fill = FALSE) %>%
  ## add some summary columns
  mutate(number_months_lack_food = rowSums(select(., Apr:Sept))) %>%
  mutate(number_items = rowSums(select(., bicycle:television)))

write_csv(interviews_plotting, path = "data_output/interviews_plotting.csv")  

## ggplot lesson

ggplot(data = interviews_plotting, aes(x = no_membrs, y = number_items)) +
  geom_point()

interviews_plot <- ggplot(data = interviews_plotting, aes(x = no_membrs, y = number_items))

interviews_plot +
  geom_jitter(alpha = 0.5, aes(color=village))

## exercise of rooms by village, color by wall type, scatterplot
ggplot(data = interviews_plotting, aes(x = village, y = rooms)) +
  geom_jitter(aes(color = respondent_wall_type))

# boxplot
ggplot(data = interviews_plotting, aes(x = respondent_wall_type, y = rooms)) +
  geom_jitter(alpha = 0.5, color = "tomato") +
  geom_boxplot(alpha = 0)

# exercise violin plot
ggplot(data = interviews_plotting, aes(x = respondent_wall_type, y = rooms)) +
  geom_jitter(alpha = 0.5, color = "tomato") +
  geom_violin(alpha = 0)

# exercise liv_count, we improved it over the lesson by placing alpha outside of the aesthetic.
ggplot(data = interviews_plotting, aes(x = respondent_wall_type, y = liv_count)) +
  geom_jitter(alpha=0.5, aes(color = memb_assoc)) +
  geom_boxplot(alpha = 0)

# barplots
# note that barplots don't have a y variable in the base aesthetic
ggplot(data = interviews_plotting, aes(x = respondent_wall_type)) +
  geom_bar(aes(fill = village), position="dodge" )

percent_wall_type <- interviews_plotting %>% 
  filter(respondent_wall_type != "cement") %>% 
  count(village, respondent_wall_type) %>% 
  group_by(village) %>% 
  mutate(percent = n / sum(n)) %>% 
  ungroup()

ggplot(percent_wall_type, aes(x = village, y = percent, fill = respondent_wall_type)) +
  geom_bar(stat = "identity", position = "dodge")
  
# make a new df for the pct membership of irrigation assoc, and plot the yes/no % by village
percent_memb_assoc <- interviews_plotting %>% 
  filter(!is.na(memb_assoc)) %>%
  count(village, memb_assoc) %>%
  group_by(village) %>% 
  mutate(percent = n / sum(n)) %>% 
  ungroup()

ggplot(percent_memb_assoc, aes(x = village, y= percent, fill = memb_assoc)) +
  geom_bar(stat="identity", position = "dodge")

## labels and titles
ggplot(percent_wall_type, aes(x = village, y = percent, fill = respondent_wall_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  ylab("Percent") +
  xlab("Wall Type") +
  ggtitle("Proportion of wall type by village")

## faceting
ggplot(percent_wall_type, aes(x = respondent_wall_type, y = percent)) +
  geom_bar(stat = "identity", position = "dodge") +
  ylab("Percent") +
  xlab("Wall Type") +
  ggtitle("Proportion of wall type by village") +
  facet_wrap(~ village) +
  theme_bw() +
  theme(panel.grid = element_blank())

## faceting by item owned % by village
percent_items <- interviews_plotting %>%
  gather (items, items_owned_logical, bicycle:no_listed_items) %>%
  filter(items_owned_logical) %>%
  count(items,village) %>% 
## add a column with the number of people in each village
  mutate(people_in_village = case_when(village == "Chirodzo" ~ 39,
                                       village == "God" ~ 43,
                                       village == "Ruaca" ~ 49)) %>% 
  mutate(percent = n / people_in_village)

# alright. now let's plot it with facets by item type. and start to really control the text elements in our theme.

ggplot(percent_items, aes(x=village, y=percent)) +
  geom_bar(stat="identity", position = "dodge") +
  facet_wrap(~ items) +
  labs(title = "Percent of respondents in each village who owned each item",
       x = "Village",
       y = "Percent of Respondents") +
  theme_bw() +
  theme(axis.text.x = element_text(colour = "grey20", size = 12, angle = 45, hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(colour = "grey20", size = 12),
        text = element_text(size = 16))

  