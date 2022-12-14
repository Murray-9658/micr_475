
# Determination of Extracellular Enzyme Activity from HPLC Analysis

## Input Files and Load Packages

“PPEE_test_2.csv” is the input file containing chromatogram data.
“metadata.csv” contains ancillary information such as soil mass, buffer
volume, etc.

``` r
library(tidyverse)

df <- read_csv("PPEE_test_2.csv")
df1 <- read_csv("PPEE_test_2.csv")
meta <- read_csv("metadata.csv")
```

## Slope Function

The below function calculates the slope of the standard curve.

``` r
extract_slope <- function(df, substrate) {
  
  std_lm <- lm(area ~ conc, data = df[[3]][[1]])
  
  std_cf <- coef(std_lm)
  
  std_slope <- std_cf[2]
}
```

## Quench Coefficient Function

This function calculates the quench coefficient from the slope of the
standard curve in homogenate and buffer. `pivot_wider` is used to widen
the dataframe so that the quench coefficient is easily calculated.

``` r
quench_fxn <- function(df) {
  
  df <- df %>% select(-data) %>%
    pivot_wider(names_from = type, values_from = slope) 
  
  df_quench <- df %>% mutate(quench_coef = standard_homog / standard_buff)
  
  df_quench
}
```

## Emission Coefficient Function

The emission coefficient is calculated from the function below. Assay
volume is called from the meta data file.

``` r
emis_fxn <- function(df, meta_df) {
  
  assay_vol <- meta %>% filter(type == "assay_volume")
  
  df_emis <- df %>% mutate(emis_coef = standard_homog /assay_vol$value)
  
  df_emis
}
```

## Net Fluorescence Function

This function calculates net fluorescence using the output df, a
reference df (that includes quench and emission coefficients), and an
object corresponding to the value of the homogenate control.

``` r
calc_net_fluor <- function(df, df_ref, ctrl_homog){
  
  pivoted <- df %>% 
    pivot_wider(names_from = type, values_from = area)

  net_pivoted <- pivoted %>% mutate(net_fluor = ((live - ctrl_homog) / df_ref$quench_coef) - ctrl)
  net_pivoted
}
```

## Activity Function

This final activity function uses previously calculated net
fluorescence, the reference df, and the meta data df to determine the
activity of each substrate associated enzyme.

``` r
calc_activity <- function(df_net_fluor, ref_df, meta_df){
  
  buffer_vol <- meta_df %>% filter(type == "buffer_volume")
homog_vol <- meta_df %>% filter(type == "homogenate_volume")
soil_mass <- meta_df %>% filter(type == "soil_mass")

activity_df <- df_net_fluor %>% mutate(activity = ((net_fluor * buffer_vol$value) /
                                                    ref_df$emis_coef * homog_vol$value * soil_mass$value))
activity_df
}
```

## Separate AMC/MUB Standards in Homogenate

``` r
df_stds_mub <- df %>% filter(substrate == "mub_std") %>% group_by(type, time) %>% nest()
df_stds_amc <- df %>% filter(substrate == "amc_std") %>% group_by(type, time) %>% nest()
```

## Add Slope to Standards df

``` r
df_stds_slope_mub <- df_stds_mub %>% mutate(slope = extract_slope(df_stds_mub))
df_stds_slope_amc <- df_stds_amc %>% mutate(slope = extract_slope(df_stds_amc))
```

## Add Quench and Emission Coefficients to Reference df

``` r
df_ref_mub_q <- quench_fxn(df_stds_slope_mub)
df_ref_amc_q <- quench_fxn(df_stds_slope_amc)

df_ref_mub_q_e <- emis_fxn(df_ref_mub_q)
df_ref_amc_q_e <- emis_fxn(df_ref_amc_q)
```

## Separate Live and Controls

``` r
live_ctrl_df <- df %>% filter(type == "live" | type == "ctrl")
live_ctrl_df_mub <- live_ctrl_df %>% filter(substrate != "amc_leu")
live_ctrl_df_amc <- live_ctrl_df %>% filter(substrate == "amc_leu")
```

## Extract Homogenate Control

``` r
df1_filt <- df1 %>% filter(type == "ctrl_homog")
wide_df1_filt <- df1_filt %>%
  pivot_wider(names_from = type, values_from = area)

ctrl_homog <- wide_df1_filt$ctrl_homog
```

## Add Net Fluorescence to df

``` r
net_fluor_mub <- calc_net_fluor(live_ctrl_df_mub, df_ref_mub_q, ctrl_homog)
net_fluor_amc <- calc_net_fluor(live_ctrl_df_amc, df_ref_amc_q, ctrl_homog)
```

## Calculate Activity and clean up dfs for plotting

``` r
activity_mub <- calc_activity(net_fluor_mub, df_ref_mub_q_e, meta)
activity_amc <- calc_activity(net_fluor_amc, df_ref_amc_q_e, meta)

activity_mub_clean <- activity_mub %>% select(substrate, time, activity)
activity_amc_clean <- activity_amc %>% select(substrate, time, activity)
```

## MUB Activity Plot

``` r
activity_mub %>% ggplot(aes(x = time, y = activity, fill = substrate, color = substrate)) +
  geom_point() +
  ylab(bquote('Activity (nmol'  ~g^-1~h^-1*')')) +
  xlab(label = "Time (hr)") +
  ggtitle(label = "Activities of MUB Hydrolyzing Enzymes") +
  theme_bw() +
  theme(panel.grid.minor = element_blank(), plot.title = element_text(hjust = 0.5))
```

![](project_script_working_files/figure-gfm/unnamed-chunk-14-1.png)

## AMC Activity Plot

``` r
activity_amc %>% ggplot(aes(x = time, y = activity, fill = substrate, color = substrate)) +
  geom_point() +
  ylab(bquote('Activity (nmol'  ~g^-1~h^-1*')')) +
  xlab(label = "Time (hr)") +
  ggtitle(label = "Activities of AMC Hydrolyzing Enzymes") +
  theme_bw() +
  theme(panel.grid.minor = element_blank(), plot.title = element_text(hjust = 0.5))
```

![](project_script_working_files/figure-gfm/unnamed-chunk-15-1.png)
