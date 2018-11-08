###########
# Section 0.0 required packages and the installation command(s)
# whenever possible, place all installation methods for all packages here at the beginning of a script.
# keep them commented out, though, as you only ever have to install once, removing and reinstalling is more trouble than it is worth, and installing packages over themselves can (rarely) lead to undefined behavior
# install.packages("gapminder")
# install.packages("tidyverse")
###########

###########
# Section 0.1: load libraries. If possible, always load up front.
###########
library(gapminder)
library(tidyverse)

###########
# Section 1.0: Greg Martin's gapminder dataframe and basic plots
###########

# Greg's  method for creating a gapminder data frame were obscure. Here's his way
data("gapminder")
gapminder
# the first command does not do what it did in his video. the data() command appears to just make an empty "promised" object named gapminder. It becomes a usable dataframe only once we run his 2nd command

# alternate method. explicitly declare a dataframe named gapminder
gapminder <- gapminder
# I don't particularly like this alternate method, but it does more resemble a normal operation for not-canned data. You'll encounter this issue frequently in R documentation -- that the data import methods for example data often have zero relation to how you actually import real data from real files. If I were king, I'd outlaw this practice.
# the reason I don't like my own alternate method is that I'm creating a dataframe named "gapminder" by evaluating the value of some other thing named "gapminder" (from the gapminder library) and assigning that thing to the data frame. amazingly, R has no problem with this, but it is poor practice to ever name anything you make any other name of anything else in your script, library or environment. The full and sensible solution will follow in the next giant comment.

# then greg prompts us to glance at the gapminder dataframe using summary()
summary(gapminder)
# he next shows us how to isolate a column "gdpPercap", take the mean of it, and assign that to a 1x1 vector "x"
x <- mean(gapminder$gdpPercap)
x

# then out of laziness, he tells us to attach() our gapminder dataframe to our environment so we never have to type those $ symbols again. without this attach function, all of the below operations on the columns of dataframe "gapminder" would have to be written as "gapminder$pop", rather than "pop", or we would have to specify "data = gapminder" in various functions. That's ok, though. We can make different choices than previous generations.
# moreover, i'm not a fan of the attach function. it makes it easier for your environment to deviate from your script, adds mystery, and makes your code less explicit. lazy cheats from a lazier era. it's 2018. we're all pretty good at typing now.
# Here's greg's attach function
attach(gapminder)
# see how this median command just works on the pop column! cool. but don't.
median(pop)
# now greg shows off the base plot system built in to R. First, a histogram of life expectancy.
hist(lifeExp)
hist(pop) # is left skewed, so try a log transform?
hist(log(pop)) # ok. looks better.
# now boxplots
boxplot(lifeExp ~ continent)
plot(lifeExp ~ gdpPercap) # x axis is power scale. log transform this too
plot(lifeExp ~ log(gdpPercap))

###############
# Section 2.0 now doing it without the recycled dataframe name and without the lazy attach function. 
# you can prove the perfect equivalence to yourself by clearing your environment and running Sections 0.0 and 0.1, then proceeding to here
##############
# just give your dataframe a name. one that isn't already taken.
mygap <- gapminder
summary(mygap)
x_mygap <- mean(mygap$gdpPercap)
median(mygap$pop)
# now greg shows off the base plot system built in to R. First, a histogram of life expectancy.
hist(mygap$lifeExp)
hist(mygap$pop) # is left skewed, so try a log transform?
hist(log(mygap$pop)) # ok. looks better.
# now boxplots
boxplot(lifeExp ~ continent, data=mygap)
plot(lifeExp ~ gdpPercap, data=mygap) # x axis is power scale. log transform this too
plot(lifeExp ~ log(gdpPercap), data=mygap)

############
# Section 3.0 dplyr manipulations and ggplots
###########
#
# from here, greg stops relying on the attach function and explicates that he's using his gapminder dataframe in the steps that use it as input. we can continue to grumble that it is a bad name for his dataframe but concede to use it so our code looks like his. or we can continue to be sticklers and explicitly use our mygap dataframe instead. I'll show the latter.

# compute the mean of life expectancy for South Africa and Ireland
# see how he names his source dataframe, then feeds it to the next step with the "and then" operator from tidyverse
mygap %>%
  select(country, lifeExp) %>% 
  filter(country == "South Africa" |
           country == "Ireland") %>% 
  group_by(country) %>% 
  summarise(Average_life = mean(lifeExp))
# do a t-test to compare the life expectancy between South Africa and Ireland
# make a new data frame too
df1 <- gapminder %>%
  select(country, lifeExp) %>% 
  filter(country == "South Africa" |
           country == "Ireland")  

t.test(data = df1, lifeExp ~ country)  

# viz 1. basic scatterplot aka "geom_point"
mygap %>% 
  filter(gdpPercap < 50000) %>% 
  ggplot(aes(x=gdpPercap, y=lifeExp)) +
  geom_point()

# viz 2. color-enhanced single plot. still busy 
mygap %>% 
  filter(gdpPercap < 50000) %>% 
  ggplot(aes(x=log(gdpPercap), y=lifeExp, col=continent, size=pop)) +
  geom_point(alpha=0.3) +
  geom_smooth(method=lm) 

# viz 3. continent-faceted scatterplots 
mygap %>% 
  filter(gdpPercap < 50000) %>% 
  ggplot(aes(x=log(gdpPercap), y=lifeExp, col=year, size=pop)) +
  geom_point(alpha=0.3) +
  geom_smooth(method=lm) +
  facet_wrap(~continent)

# linear regression models
# general form of lm is
# lm(y ~ x)
lm(lifeExp ~ gdpPercap, data=mygap)
# summary of lm to get the p-value on the console
lm(lifeExp ~ gdpPercap, data=mygap) %>% 
  summary
# now with two "x" variables to test
lm(lifeExp ~ gdpPercap+pop, data=mygap) %>% 
  summary
# try a log transform of each
lm(lifeExp ~ log(gdpPercap)+log(pop), data=mygap) %>% 
  summary
