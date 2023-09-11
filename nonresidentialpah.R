library(readxl)
library(tidyverse)
library(readr)
library(stringr)
library(reshape2)
library(table1)
library(EnvStats)



#####----
#set working directory 
setwd("/Users/godsgiftnkechichukwuonye/Library/CloudStorage/Box-Box/R21 Wildfire and Flash Floods - shared all/Results/Turner Lab Results/Combined datasets with MRA lab ID")

#Soil PAH=====
pah <- read_xlsx("Combined_PAH_Data.xlsx", sheet= "totalsoil", col_names = TRUE) 
head(pah)
pah<- pah<- pah[pah$TYPE != "community", ]  
pah$RESULT<- as.numeric(pah$RESULT)
pah$detect = ifelse(pah$RESULT>0,"Detect","Non-Detect")
pah$detect<- replace_na(pah$detect, "Non-Detect")
pah$RESULT<- replace_na(pah$RESULT, 0)
pah<- pah[pah$ANALYTE != "1-Methylnaphthalene", ] 
pah<- pah[pah$ANALYTE != "2-Chloronaphthalene", ] 
table1(~ detect|ANALYTE+Location, 
       data=pah,
       overall=F)
pah$corrected<- replace_na(pah$RESULT)
pah$corrected <- ifelse(pah$corrected <=(0.00000),
                        formatC(signif(((as.numeric(pah$DL)/2)),digits=2), digits=2,format="fg", flag="#"),
                        formatC(signif((pah$corrected),digits=4), digits=4,format="fg", flag="#"))


pah$corrected<- as.numeric(pah$corrected)

table1(~corrected|ANALYTE+TYPE, 
       data=pah,
       render.continuous=c(.="Mean (sd)", .="Median [Min, Max]",
                           .="GMEAN (GSD)"))


pah_short <-pah[c(7:10, 19, 37)]
pah_wide<- datawizard::data_to_wide(
  pah_short,
  id_cols = NULL,
  values_from = "corrected",
  names_from = "ANALYTE",
  values_drop_na = TRUE)


pah_wide$EPA16<- with(pah_wide,    (pah_wide$Acenaphthene+
                                   pah_wide$Acenaphthylene+
                                   pah_wide$Anthracene+
                                   pah_wide$`Benzo(a)anthracene`+
                                   pah_wide$`Benzo(a)pyrene`+
                                   pah_wide$`Benzo(b)fluoranthene`+
                                   pah_wide$`Benzo(k)fluoranthene`+
                                   pah_wide$`Benzo(g,h,i)perylene`+
                                   pah_wide$Chrysene+
                                   pah_wide$`Dibenz(a,h)anthracene`+
                                   pah_wide$Fluoranthene+
                                     pah_wide$Fluorene+
                                     pah_wide$`Indeno(1,2,3-cd)pyrene`+
                                     pah_wide$Phenanthrene+
                                     pah_wide$Pyrene+
                                     pah_wide$Naphthalene))
                                
                          
write_csv(pah_wide, "pah_nonresidential.csv")

pah2 <- read_xlsx("pah_nonresidential.xlsx", sheet= "pah_nonresidential", col_names = TRUE) 


ggplot(pah_wide, aes(x=pah2$Location, y=log(pah2$EPA16),
                     fill = Depth,
                     color= Type)) +
  stat_boxplot(geom = "errorbar",
               width = 0.5,
               color = 1) +  
  geom_boxplot(alpha = 0.5,     
               color = 1,          
               outlier.colour = 2) +
  geom_jitter(color=2, size=1.2) +
  theme(axis.text.x=element_text(size=15))+
  labs(y = "Total EPA 16 PAH Concentration (mg/kg)",
       x = "Location")+
  stat_summary(fun.y=mean, geom="point", shape=20, size=5, color="blue", fill="white") +
scale_y_continuous()

kruskal.test(pah2$`EPA16 (mg/kg)`, pah2$Location)
kruskal.test(pah2$`EPA16 (mg/kg)`, pah2$Depth)

community <- read_xlsx("Combined_PAH_Data.xlsx", sheet= "community", col_names = TRUE)
head(community)
community$RESULT<- as.numeric(community$RESULT)
community$detect = ifelse(community$RESULT>0,"Detect","Non-Detect")
community$detect<- replace_na(community$detect, "Non-Detect")
community$RESULT<- replace_na(community$RESULT, 0)
#community<- community[community$ANALYTE != "1-Methylnaphthalene", ] 
#pah<- pah[pah$ANALYTE != "2-Chloronaphthalene", ] 
table1(~ detect|ANALYTE+MATRIX, 
       data=community,
       overall=F)
table1(~ detect|ANALYTE, 
       data=community,
       overall=F)
community$corrected<- replace_na(community$RESULT)
community$corrected <- ifelse(community$corrected <=(0.00000),
                        formatC(signif(((as.numeric(community$DL)/2)),digits=2), digits=2,format="fg", flag="#"),
                        formatC(signif((community$corrected),digits=4), digits=4,format="fg", flag="#"))


community$corrected<- as.numeric(community$corrected)

table1(~corrected|ANALYTE+MATRIX, 
       data=community,
       render.continuous=c(.="Mean (sd)", .="Median [Min, Max]",
                           .="GMEAN (GSD)"))

table1(~corrected|ANALYTE, 
       data=community,
       render.continuous=c(.="Mean (sd)", .="Median [Min, Max]",
                           .="GMEAN (GSD)"))

community_short <-community[c(7:9, 17, 35)]
community_short$corrected<- as.numeric(community_short$corrected)
length(community_short)



