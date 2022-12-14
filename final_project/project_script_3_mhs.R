library(tidyverse)


# Slope fxn
extract_slope <- function(df, substrate) {
  
  std_lm <- lm(area ~ conc, data = df[[1]])
  
  std_cf <- coef(std_lm)
  
  std_slope <- std_cf[2]
  
}

# Quench fxn

quench_fxn <- function(df, substrate) {
  
  ### Drew code here
  homog.over.buffer = mean(df$type == "homogenate") / mean(df$type=="buffer")
  
  df %>% 
    group_by(time) %>%
    homog.over.buffer = mean(.$type == "homogenate") / mean(.$type=="buffer")
  ### End Drew code
}

# importing files
df <- read_csv("PPEE_test_2.csv")

meta <- read_csv("metadata.csv")


# separate stds in homog
df_stds_mub <- df %>% filter(substrate == "mub_std") %>% group_by(type, time) %>% nest()
df_stds_amc <- df %>% filter(substrate == "amc_std") %>% group_by(type, time) %>% nest()

# Add slope to df
df_stds_slope_mub <- df_stds_mub %>% mutate(slope = extract_slope(data, substrate))
df_stds_slope_amc <- df_stds_amc %>% mutate(slope = extract_slope(data, substrate))

