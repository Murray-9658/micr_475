library(tidyverse)

#Read in raw data
df <- read_csv("PPEE_test_0.csv")
meta <- read_csv("metadata.csv")

#Separate standard homogenates
df_stds <- df %>% filter(type == "std_homogenate") %>% group_by(substrate) %>% nest()

#Separate standard buffers
df_buff <- df %>% filter(type == "std_buffer") %>% group_by(substrate) %>% nest()

#Separate live
df_live <- df %>% filter(type == "live") %>% group_by(spec_substrate)

#Separate control
df_ctrl <- df %>% filter(type == "control") %>% group_by(spec_substrate)

extract_slope <- function(df, sub) {

  std_lm <- lm(area ~ concentration, data = df[[1]])
  
  std_cf <- coef(std_lm)
  
  std_slop <- std_cf[2]
  
}

df_stds_slope <- df_stds %>% mutate(slope = extract_slope(data, substrate))
df_buff_slope <- df_buff %>% mutate(slope = extract_slope(data, substrate))


# Quench Coef

  df_stds_slope_mub_filt <- filter(df_stds_slope, substrate == "mub")
  df_stds_slope_amc_filt <- filter(df_stds_slope, substrate == "amc")
  
  df_buff_slope_mub_filt <- filter(df_buff_slope, substrate == "mub")
  df_buff_slope_amc_filt <- filter(df_buff_slope, substrate == "amc")
  
  quench_coef_mub <- (df_stds_slope_mub_filt$slope / df_buff_slope_mub_filt$slope)
  
  quench_coef_amc <- (df_stds_slope_amc_filt$slope / df_buff_slope_amc_filt$slope)
  
  
                              

# Emission Coef
  
  assay_vol <- filter(meta, type == "assay_volume")
  
 emis_coef_mub <- (df_stds_slope_mub_filt$slope / assay_vol$value)
 
 emis_coef_amc <- (df_stds_slope_amc_filt$slope / assay_vol$value)




# homogenate_control

control_homogenate_df <- df %>% filter(type == "control_homogenate")
control_homogenate <- control_homogenate_df$area



# net fluorescence calc
calc_net_fluor <- function(df_live, control_homogenate, quench_coef_mub,
                           df_ctrl) {
  
  net_fluor_df <- (((df_live - control_homogenate)/quench_coef_mub) - df_ctrl)
}


# fluroesence calc math
net_fluor_df <- (((df_live$area - control_homogenate)/quench_coef_mub) - df_ctrl$area)
  



net_fluor <- df_live %>% mutate(net_fluor_col = calc_net_fluor(data, control_homogenate,
                                                               quench_coef_mub))





# enzyme activity calc

calc_activity <- function(net_fluor, buffer_vol, emis_coef, homogenate_vol,
                          soil_mass) {
  
  activity <- ((net_fluor * buffer_vol) / emis_coef * homogenate_vol * soil_mass)
}






