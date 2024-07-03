packages <- c("ggplot2", "GGally")                          
invisible(lapply(packages, require, character.only = TRUE ))
source("Data/R/dataPreprocess.R")


# colnames(data)
# [1] "analysisName"         "originalName"         "age"                  "uncertainty"          "reference"           
# [6] "mineral"              "method"               "rockType"             "lithology"            "unit"                
# [11] "group"                "easting"              "northing"             "datum"                "dataComment"         
# [16] "nameChange"           "locationEstimated"    "uncertaintyEstimated" "year"  
ggpairs(data %>% select(easting, northing, age))

# Uncertainty
ggplot(data, aes(x=uncertainty, color = uncertaintyEstimated)) +
  geom_histogram(fill = "white", alpha = 0.5, position = "identity")+
  theme_bw()+
  facet_wrap(method ~.)

# Age 
ggplot(data, aes(x = easting, y = age, color = method)) + geom_point()+ theme_bw() # GOOD! seems pretty indep of method used

ggplot(data, aes(x = easting, y = age, color = year)) + geom_point()+ theme_bw()
ggplot(data, aes(x = northing, y = age)) + geom_point()+ theme_bw()
ggplot(data, aes(x = easting, y = age)) + geom_point()+ theme_bw()

ggplot(data, aes(x=age)) +
  geom_histogram( alpha = 0.5, position = "identity") +theme_bw()+
  facet_wrap(eastGroup ~., ncol = 4)
ggplot(data, aes(x=age)) +
  geom_histogram( alpha = 0.5, position = "identity") +theme_bw()+
  facet_grid(northGroup ~.)


ggplot(data, aes(x = easting, y = northing, size = age, alpha = 0.5, color = locationEstimated)) + 
  geom_point()+ theme_bw()

# Quick fit
easyModel <- lm(age ~ easting + northing, data = data)
summary(easyModel)

ggplot(data, aes(x = easting, y = age)) + 
  geom_point()+ theme_bw()+geom_smooth(method='lm') + 
  facet_wrap(northGroup ~.)


# Cor plot
rmFromPlot <- c("analysisName", "originalName", "datum", "reference", "lithology", "unit", "group", "dataComment")
ggpairs(data %>% select(!rmFromPlot))
        



###################################
### MAP PLOT ###


# Notes:
# - AnalysisNames: All are unique(no repeats)
# - OriginalName: 47 not renames (i.e. are NAs), 3 entries are 1
# - Age: range 124.2 - 83.5
# - Uncertainty: 0.04 - 12; 
# - Reference: 40 diff refs, a few unpublished, most from 1981 (37)
# - Mineral: 4 are zircon/sphene, the rest are zircon (213)



