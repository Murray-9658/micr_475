library(tidyverse)


# Slope fxn
extract_slope <- function(df, substrate) {
  
  std_lm <- lm(area ~ conc, data = df[[3]][[1]])
  
  std_cf <- coef(std_lm)
  
  std_slope <- std_cf[2]
  
}

# Quench fxn
quench_fxn <- function(df) {
  
  df <- df %>% select(-data) %>%
    pivot_wider(names_from = type, values_from = slope) 
  
  df_quench <- df %>% mutate(quench_coef = standard_homog / standard_buff)
  
  df_quench
}

# Emission coef fxn

emis_fxn <- function(df, meta_df) {
  
  assay_vol <- meta %>% filter(type == "assay_volume")
  
  df_emis <- df %>% mutate(emis_coef = standard_homog /assay_vol$value)
  
  df_emis
}

# Net Fluoresence Fxn

calc_net_fluor <- function(df, df_ref, ctrl_homog){
  
  pivoted <- df %>% 
    pivot_wider(names_from = type, values_from = area)

  net_pivoted <- pivoted %>% mutate(net_fluor = ((live - ctrl_homog) / df_ref$quench_coef)
                                    - ctrl)
  net_pivoted
}

# Activity Fxn


# importing files
df <- read_csv("PPEE_test_2.csv")
df1 <- read_csv("PPEE_test_2.csv")

meta <- read_csv("metadata.csv")


# separate stds in homog
df_stds_mub <- df %>% filter(substrate == "mub_std") %>% group_by(type, time) %>% nest()
df_stds_amc <- df %>% filter(substrate == "amc_std") %>% group_by(type, time) %>% nest()

# Add slope to df
df_stds_slope_mub <- df_stds_mub %>% mutate(slope = extract_slope(df_stds_mub))
df_stds_slope_amc <- df_stds_amc %>% mutate(slope = extract_slope(df_stds_amc))


# Add quench coef to ref df
df_ref_mub_q <- quench_fxn(df_stds_slope_mub)
df_ref_amc_q <- quench_fxn(df_stds_slope_amc)


# Add emis coef to ref df
df_ref_mub_q_e <- emis_fxn(df_ref_mub_q)
df_ref_amc_q_e <- emis_fxn(df_ref_amc_q)


# Separate live / ctrls 
live_ctrl_df <- df %>% filter(type == "live" | type == "ctrl")
live_ctrl_df_mub <- live_ctrl_df %>% filter(substrate != "amc_leu")
live_ctrl_df_amc <- live_ctrl_df %>% filter(substrate == "amc_leu")

# Extracting ctrl_homg
df1_filt <- df1 %>% filter(type == "ctrl_homog")
wide_df1_filt <- df1_filt %>%
  pivot_wider(names_from = type, values_from = area)

ctrl_homog <- wide_df1_filt$ctrl_homog

# Add net fluoresence
net_fluor_mub <- calc_net_fluor(live_ctrl_df_mub, df_ref_mub_q, ctrl_homog)
net_fluor_amc <- calc_net_fluor(live_ctrl_df_amc, df_ref_amc_q, ctrl_homog)




