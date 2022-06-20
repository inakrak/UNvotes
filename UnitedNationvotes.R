library(dplyr)
library(openxlsx)
library(tidyr)


## download the UN votes from site ('https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/LEJUQZ')

load("/UNVotes-1.RData")
## as completevotes


#download the PolityV democratic scores from ('http://www.systemicpeace.org/inscrdata.html')
polity <- read.xlsx("/p5v2018.xlsx",
                     sheet = "p5v2018", startRow = 1, colNames = TRUE)



# polity has no data after 2018 so we filter UN data acc to that and select key variables only
UNvars <- completeVotes %>%filter(year<2019) %>% select(Country,Countryname,vote,yes,no,year,unres,descr,resid)
polityvars <- polity %>% filter(year>1945 & year<2019) %>% select(scode,country,polity,polity2,year)

# Polity sd and mean per year
polityvarsAGG <- polityvars %>% group_by(year) %>% summarise(sdPolityBYyear=sd(polity2),meanPolityBYyear=mean(polity2)) %>% ungroup()
polityvars<-merge(polityvars,polityvarsAGG,by="year",all.x=T)
# Normalised Polity2
polityvars$polity2zscoreYear = (polityvars$polity2-polityvars$meanPolityBYyear)/polityvars$sdPolityBYyear


### match UN PolityV country names
Countryequivalences  <- read.table( text=
"Uncountry	polity equivalence
Afghanistan	Afghanistan
Albania	Albania
Algeria	Algeria
Andorra	Spain
Angola	Angola
Antigua & Barbuda	Trinidad and Tobago
Antigua and Barbuda	Trinidad and Tobago
Argentina	Argentina
Armenia	Armenia
Australia	Australia
Austria	Austria
Azerbaijan	Azerbaijan
Bahamas	Dominican Republic
Bahrain	Bahrain
Bangladesh	Bangladesh
Barbados	Trinidad and Tobago
Belarus	Belarus
Belgium	Belgium
Belize	Mexico
Benin	Benin
Bhutan	Bhutan
Bolivia	Bolivia
Bolivia (Plurinational State of)	Bolivia
Bosnia & Herzegovina	Bosnia
Bosnia and Herzegovina	Bosnia
Botswana	Botswana
Brazil	Brazil
Brunei	Malaysia
Brunei Darussalam	Malaysia
Bulgaria	Bulgaria
Burkina Faso	Burkina Faso
Burundi	Burundi
Cabo Verde	Cape Verde
Cambodia	Cambodia
Cameroon	Cameroon
Canada	Canada
Cape Verde	Cape Verde
Central African Republic	Central African Republic
Chad	Chad
Chile	Chile
China	China
Colombia	Colombia
Comoros	Comoros
Congo	Congo Brazzaville
Congo - Brazzaville	Congo Brazzaville
Congo - Kinshasa	Congo Kinshasa
Costa Rica	Costa Rica
Côte d'Ivoire	Cote D'Ivoire
Côte D'Ivoire	Cote D'Ivoire
Croatia	Croatia
Cuba	Cuba
Cyprus	Cyprus
Czech Republic	Czech Republic
Czechia	Czech Republic
Czechoslovakia	Czechoslovakia
Democratic People's Republic of Korea	Korea North
Democratic Republic of the Congo	Congo Kinshasa
Denmark	Denmark
Djibouti	Djibouti
Dominica	Trinidad and Tobago
Dominican Republic	Dominican Republic
Ecuador	Ecuador
Egypt	Egypt
El Salvador	El Salvador
Equatorial Guinea	Equatorial Guinea
Eritrea	Eritrea
Estonia	Estonia
Eswatini	Swaziland
Ethiopia	Ethiopia
Fiji	Fiji
Finland	Finland
France	France
Gabon	Gabon
Gambia	Gambia
Gambia (Islamic Republic of the)	Gambia
Georgia	Georgia
German Democratic Republic	Germany East
German Federal Republic	Germany West
Germany	Germany
Ghana	Ghana
Greece	Greece
Grenada	Trinidad and Tobago
Guatemala	Guatemala
Guinea	Guinea
Guinea Bissau	Guinea-Bissau
Guinea-Bissau	Guinea-Bissau
Guyana	Guyana
Haiti	Haiti
Honduras	Honduras
Hungary	Hungary
Iceland	Norway
India	India
Indonesia	Indonesia
Iran	Iran
Iran (Islamic Republic of)	Iran
Iraq	Iraq
Ireland	Ireland
Israel	Israel
Italy	Italy
Jamaica	Jamaica
Japan	Japan
Jordan	Jordan
Kazakhstan	Kazakhstan
Kenya	Kenya
Kiribati	Solomon Islands
Kuwait	Kuwait
Kyrgyzstan	Kyrgyzstan
Lao People's Democratic Republic	Laos
Laos	Laos
Latvia	Latvia
Lebanon	Lebanon
Lesotho	Lesotho
Liberia	Liberia
Libya	Libya
Liechtenstein	Austria
Lithuania	Lithuania
Luxembourg	Luxembourg
Madagascar	Madagascar
Malawi	Malawi
Malaysia	Malaysia
Maldives	Mauritius
Mali	Mali
Malta	Italy
Marshall Islands	Solomon Islands
Mauritania	Mauritania
Mauritius	Mauritius
Mexico	Mexico
Micronesia (Federated States of)	Solomon Islands
Moldova	Moldova
Monaco	France
Mongolia	Mongolia
Montenegro	Montenegro
Morocco	Morocco
Mozambique	Mozambique
Myanmar	Myanmar (Burma)
Myanmar (Burma)	Myanmar (Burma)
NA	NA
Namibia	Namibia
Nauru	Solomon Islands
Nepal	Nepal
Netherlands	Netherlands
New Zealand	New Zealand
Nicaragua	Nicaragua
Niger	Niger
Nigeria	Nigeria
North Korea	Korea North
North Macedonia	Kosovo
Norway	Norway
Oman	Oman
Pakistan	Pakistan
Palau	Solomon Islands
Panama	Panama
Papua New Guinea	Papua New Guinea
Paraguay	Paraguay
Peru	Peru
Philippines	Philippines
Poland	Poland
Portugal	Portugal
Qatar	Qatar
Republic of Korea	Korea South
Republic of Moldova	Moldova
Romania	Romania
Russia	Russia
Russian Federation	Russia
Rwanda	Rwanda
Saint Kitts and Nevis	Trinidad and Tobago
Saint Lucia	Trinidad and Tobago
Saint Vincent and the Grenadines	Trinidad and Tobago
Samoa	Solomon Islands
San Marino	Italy
São Tomé & Príncipe	Cape Verde
Sao Tome and Principe	Cape Verde
Saudi Arabia	Saudi Arabia
Senegal	Senegal
Serbia	Serbia
Serbia and Montenegro	Serbia and Montenegro
Seychelles	Mauritius
Sierra Leone	Sierra Leone
Singapore	Singapore
Slovakia	Slovak Republic
Slovenia	Slovenia
Solomon Islands	Solomon Islands
Somalia	Somalia
South Africa	South Africa
South Korea	Korea South
South Sudan	South Sudan
Spain	Spain
Sri Lanka	Sri Lanka
St. Kitts & Nevis	Trinidad and Tobago
St. Lucia	Trinidad and Tobago
St. Vincent & Grenadines	Trinidad and Tobago
Sudan	Sudan
Suriname	Suriname
Swaziland	Swaziland
Sweden	Sweden
Switzerland	Switzerland
Syria	Syria
Syrian Arab Republic	Syria
Taiwan, Province of China	Taiwan
Tajikistan	Tajikistan
Tanzania	Tanzania
Thailand	Thailand
The former Yugoslav Republic of Macedonia	Macedonia
Timor-Leste	Timor Leste
Togo	Togo
Tonga	Solomon Islands
Trinidad & Tobago	Trinidad and Tobago
Trinidad and Tobago	Trinidad and Tobago
Tunisia	Tunisia
Turkey	Turkey
Turkmenistan	Turkmenistan
Tuvalu	Solomon Islands
Uganda	Uganda
Ukraine	Ukraine
United Arab Emirates	UAE
United Kingdom	United Kingdom
United Kingdom of Great Britain and Northern Ireland	United Kingdom
United Republic of Tanzania	Tanzania
United States	United States                   
United States of America	United States                   
Uruguay	Uruguay
Uzbekistan	Uzbekistan
Vanuatu	Solomon Islands
Venezuela	Venezuela
Venezuela, Bolivarian Republic of	Venezuela
Viet Nam	Vietnam
Vietnam	Vietnam
Yemen	Yemen
Yemen Arab Republic	Yemen
Yemen People's Republic	Yemen
Yugoslavia	Yugoslavia
Zambia	Zambia
Zanzibar	Mauritius
Zimbabwe	Zimbabwe",
header=TRUE, row.names = NULL, sep= "\t", quote="\"")


UNvars <- merge(UNvars,Countryequivalences,by.x="Countryname",by.y="Uncountry")

UNvars$concatyear <- paste(UNvars$polity.equivalence,UNvars$year)

polityvars$concat <- paste(polityvars$country,polityvars$year)


UNvars2 <- merge(UNvars,polityvars,by.x="concatyear",by.y="concat", all.x=T)

UNvars2 <- UNvars2 %>% rename(year=year.x)

UNvars2$vote[UNvars2$vote==3]<--1
UNvars2$vote[UNvars2$vote==2]<-0
UNvars2$vote[UNvars2$vote==8]<-0
UNvars2$vote[UNvars2$vote==9]<-0

UNvars2$polity2 <- (UNvars2$polity2+10)/2 


#fill out empty polity2 values
UNvars2 <- UNvars2 %>% group_by(Countryname) %>% tidyr::fill(polity2, .direction="downup") %>% ungroup()
UNvars2 <- UNvars2 %>% group_by(Countryname) %>% tidyr::fill(polity2zscoreYear, .direction="downup") %>% ungroup()


MeanPolityByUNresandVote <- aggregate(UNvars2$polity2, list(UNvars2$vote,UNvars2$resid), FUN= mean, na.action = na.omit)
colnames(MeanPolityByUNresandVote) <- c("vote","resid","PolityVmean")

MeanPolityZscoredByUNresandVote <- aggregate(UNvars2$polity2zscoreYear, list(UNvars2$vote,UNvars2$resid), FUN= mean, na.action = na.omit)
colnames(MeanPolityZscoredByUNresandVote) <- c("vote","resid","PolityVmeanZscored")

LengthUNresandVote <- UNvars2 %>% group_by(vote,resid) %>% summarise(obs=n())


UNvotesSummary <- merge(MeanPolityByUNresandVote,LengthUNresandVote,by=c("vote","resid"), na.action = na.omit)
UNvotesSummary <- merge(UNvotesSummary,MeanPolityZscoredByUNresandVote,by=c("vote","resid"), na.action = na.omit)



aa<-(UNvars2 %>% select(resid,unres,descr,year))
bb<-unique(aa[,c("resid","unres","descr","year")])

UNvotesSummary <- left_join(UNvotesSummary,bb, by="resid")
VoteonRussiaInvasion <- "other Resolution vote"
UNvotesSummary <- cbind(UNvotesSummary,VoteonRussiaInvasion)

### vote on resolution A/ES-11/L.1
VoteonUkrRus  <- read.table( text=
"Countryname	vote on Ukraine
Afghanistan	y
Albania	y
Algeria	abst
Andorra	y
Angola	abst
Antigua and Barbuda	y
Argentina	y
Armenia	abst
Australia	y
Austria	y
Azerbaijan	abst
Bahamas	y
Bahrain	y
Bangladesh	abst
Barbados	y
Belarus	n
Belgium	y
Belize	y
Benin	y
Bhutan	y
Bolivia (Plurinational State of)	abst
Bosnia and Herzegovina	y
Botswana	y
Brazil	y
Brunei Darussalam	y
Bulgaria	y
Burkina Faso	abst
Burundi	abst
Cabo Verde	y
Cambodia	y
Cameroon	abst
Canada	y
Central African Republic	abst
Chad	y
Chile	y
China	abst
Colombia	y
Comoros	y
Congo	abst
Costa Rica	y
Côte D'Ivoire	y
Croatia	y
Cuba	abst
Cyprus	y
Czech Republic	y
Democratic People's Republic of Korea	n
Democratic Republic of the Congo	y
Denmark	y
Djibouti	y
Dominica	y
Dominican Republic	y
Ecuador	y
Egypt	y
El Salvador	abst
Equatorial Guinea	abst
Eritrea	n
Estonia	y
Ethiopia	abst
Fiji	y
Finland	y
France	y
Gabon	y
Gambia (Islamic Republic of the)	y
Georgia	y
Germany	y
Ghana	y
Greece	y
Grenada	y
Guatemala	y
Guinea	abst
Guinea Bissau	abst
Guyana	y
Haiti	y
Honduras	y
Hungary	y
Iceland	y
India	abst
Indonesia	y
Iran (Islamic Republic of)	abst
Iraq	abst
Ireland	y
Israel	y
Italy	y
Jamaica	y
Japan	y
Jordan	y
Kazakhstan	abst
Kenya	y
Kiribati	y
Kuwait	y
Kyrgyzstan	abst
Lao People's Democratic Republic	abst
Latvia	y
Lebanon	y
Lesotho	y
Liberia	y
Libya	y
Liechtenstein	y
Lithuania	y
Luxembourg	y
Madagascar	abst
Malawi	y
Malaysia	y
Maldives	y
Mali	abst
Malta	y
Marshall Islands	y
Mauritania	y
Mauritius	y
Mexico	y
Micronesia (Federated States of)	y
Monaco	y
Mongolia	abst
Montenegro	y
Morocco	abst
Mozambique	abst
Myanmar	y
Namibia	abst
Nauru	y
Nepal	y
Netherlands	y
New Zealand	y
Nicaragua	abst
Niger	y
Nigeria	y
Norway	y
Oman	y
Pakistan	abst
Palau	y
Panama	y
Papua New Guinea	y
Paraguay	y
Peru	y
Philippines	y
Poland	y
Portugal	y
Qatar	y
Republic of Korea	y
Republic of Moldova	y
Romania	y
Russian Federation	n
Rwanda	y
Saint Kitts and Nevis	y
Saint Lucia	y
Saint Vincent and the Grenadines	y
Samoa	y
San Marino	y
Sao Tome and Principe	y
Saudi Arabia	y
Senegal	abst
Serbia	y
Seychelles	y
Sierra Leone	y
Singapore	y
Slovakia	y
Slovenia	y
Solomon Islands	y
Somalia	y
South Africa	abst
South Sudan	abst
Spain	y
Sri Lanka	abst
Sudan	abst
Suriname	y
Swaziland	abst
Sweden	y
Switzerland	y
Syrian Arab Republic	n
Tajikistan	abst
Thailand	y
The former Yugoslav Republic of Macedonia	y
Timor-Leste	y
Togo	abst
Tonga	y
Trinidad and Tobago	y
Tunisia	y
Turkey	y
Turkmenistan	abst
Tuvalu	y
Uganda	abst
Ukraine	y
United Arab Emirates	y
United Kingdom of Great Britain and Northern Ireland	y
United Republic of Tanzania	abst
United States of America	y
Uruguay	y
Uzbekistan	abst
Vanuatu	y
Venezuela, Bolivarian Republic of	abst
Viet Nam	abst
Yemen	y
Zambia	y
Zimbabwe	abst",
header=TRUE, row.names = NULL, sep= "\t", quote="\"")

##vote on Ukraine results
UkrRes <- merge(UNvars2,VoteonUkrRus, by.x="Countryname", by.y="Countryname")
UkrRes$vote.on.Ukraine  <- as.factor(UkrRes$vote.on.Ukraine)
UkrRes2 <- UkrRes %>% filter(year==2018) %>% group_by(vote.on.Ukraine) %>%
  summarise(polity2=mean(polity2),
   polity2zscoreYear=mean(polity2zscoreYear))

UkrRes2

### Add the YES and NO vote PolityV results on Russian Invasion of Ukraine UN resolution in the UNvotesSummary df
UNvotesSummary <- rbind(UNvotesSummary, c(-1,"n/a",2.1,5,-1.6,"A/ES-11/L","To adopt a resolution deploring 'in the strongest terms the aggression by the Russian Federation against Ukraine' in violation of the UN Charter and demanding that Russia 'immediately cease its use of force' against eastern European country.",2022,"No Condemnation"))
UNvotesSummary <- rbind(UNvotesSummary, c(1,"n/a",8.27,141,0.4,"A/ES-11/L","To adopt a resolution deploring 'in the strongest terms the aggression by the Russian Federation against Ukraine' in violation of the UN Charter and demanding that Russia 'immediately cease its use of force' against eastern European country.",2022,"Condemnation"))

UNvotesSummary$VoteonRussiaInvasion<-as.factor(UNvotesSummary$VoteonRussiaInvasion)
UNvotesSummary$vote<-as.factor(UNvotesSummary$vote)
UNvotesSummary$PolityVmean <- as.numeric(UNvotesSummary$PolityVmean)
UNvotesSummary$PolityVmeanZscored <- as.numeric(UNvotesSummary$PolityVmeanZscored)
UNvotesSummary$obs <- as.numeric(UNvotesSummary$obs)

#create the polityV by group size
UNvotesSummary <- UNvotesSummary %>% group_by(obs) %>% mutate(PolityZscoredbyObs=scale(PolityVmeanZscored)) %>% ungroup()
UNvotesSummary$PolityZscoredbyObs <- as.numeric(UNvotesSummary$PolityZscoredbyObs)

UNvotesSummary$voteWord <- as.character(UNvotesSummary$vote) 
UNvotesSummary["voteWord"][UNvotesSummary["voteWord"] == "-1"] <- "No"
UNvotesSummary["voteWord"][UNvotesSummary["voteWord"] == "1"] <- "Yes"
UNvotesSummary["voteWord"][UNvotesSummary["voteWord"] == "0"] <- "Abstain/Novote"
UNvotesSummary$voteWord <- as.factor(UNvotesSummary$voteWord) 
###


####GRAPHS
plot(UNvotesSummary$PolityVmean,UNvotesSummary$obs)

library(ggplot2)

ggplot(UNvotesSummary, aes(x=PolityZscoredbyObs, y=obs, col=VoteonRussiaInvasion)) +
  geom_point(data=UNvotesSummary[UNvotesSummary$VoteonRussiaInvasion=="other Resolution vote",], col="grey", size=3, alpha = 0.2)+
  geom_point(data=UNvotesSummary[UNvotesSummary$VoteonRussiaInvasion =="Condemnation",], col="dark green", size=3)+
  geom_point(data=UNvotesSummary[UNvotesSummary$VoteonRussiaInvasion=="No Condemnation",], col="red", size=3)+
  theme_bw()+
  theme(
    legend.position = c(.95, .95),
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.margin = margin(6, 6, 6, 6)
  )+
  ggtitle("UN General Assembly Yes/No/Abstain votes by Resolution since 1945")+  theme(plot.title = element_text(hjust = 0.5))+
        xlab("Mean PolityV score of countries by resolution and vote option (normalised by year and how big the consensus)")+
      ylab("number of countries")


library(plotly)

#plot_ly(data = UNvotesSummary, x = ~PolityZscoredbyObs, y = ~obs, color = ~VoteonRussiaInvasion, text = ~paste("voted:",voteWord,", Resolution:",descr))

