library(tidyverse)
library(ggplot2)
library(ggimage)
rm(list = ls())

traditional <- 
  read_csv("teams_traditional.csv") %>%
  select(TEAM, GP, TOV)
opponent <- 
  read_csv("teams_opponent.csv") %>%
  select(TEAM, `OPP\nTOV`)
logos <-
  read_csv("https://raw.githubusercontent.com/jeremydumalig/DataBank/master/logos.csv") %>%
  select(TEAM, URL)

teams <- 
  merge(traditional, 
        opponent,
        by='TEAM') %>%
  mutate(TOV = TOV / GP,
         `OPP TOV` = `OPP\nTOV` / GP,
         d_TOV = round(TOV - mean(TOV), 1),
         d_OPPTOV = round(`OPP TOV` - mean(`OPP TOV`), 1)) %>%
  select(TEAM, TOV, `OPP TOV`, d_TOV, d_OPPTOV) %>%
  merge(logos,
        by='TEAM')

teams %>%
  ggplot(aes(x=d_TOV,
             y=d_OPPTOV)) +
  geom_hline(yintercept=0, linetype="dashed") +
  geom_vline(xintercept=0, linetype="dashed") +
  geom_image(aes(image=URL),
             size=0.1,
             stat='identity') +
  labs(title="Which teams commit and force the most turnovers?",
       subtitle="NBA Regular Season | Through December 25, 2022",
       caption="* Compared to League Average *",
       x="Turnovers Per Game *",
       y="Forced Turnovers Per Game") +
  theme_linedraw() +
  theme(
    plot.margin = margin(1, 0.5, 0.5, 0.5, "cm"),
    plot.background = element_rect(fill = "grey90",
                                   color = "black"),
    legend.box.background = element_rect(size=0.75),
    axis.title.x = element_text(size=14),
    axis.title.y = element_text(size=14),
    plot.title = element_text(size=18,
                              face="bold"),
    plot.subtitle = element_text(size=14),
    plot.caption = element_text(size=10))
