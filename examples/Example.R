#' ---	
#' title: 'geocleaMT: An R package to cleaning geographical data from electronic biodatabases'	
#' author: "Viviana R-Alarcon and Daniel R Miranda-Esquivel (dmiranda@uis.edu.co)"	
#' date: '`r Sys.Date()`'	
#' output:	
#'   pdf_document: default	
#'   html_document:	
#'     css: style.css	
#' vignette: |	
#'   %\VignetteIndexEntry{'geocleaMT: An R package to cleaning geographical data from electronical biodatabases'} %\VignetteEngine{knitr::rmarkdown} %\usepackage[utf8]{inputenc}	
#' ---	
#' 	
#' 	
knitr::opts_chunk$set(cache=TRUE)	
#' 	
#' 	
#' _**geocleaMT**_ is a cleaning protocol for distributional data and an	
#'     automated tool to provide the necessary data mining process before any diversity	
#'     analysis. The protocol takes into account the most common mistakes found in	
#'     distributional records and attempts to minimize its possibility, increasing	
#'     users confidence in their data. All functions use as input a basic table with	
#'     at least three columns species/ decimalLatitude/ decimalLongitude, and save	
#'     the results in the same format after a specific task is performed. Additionally,	
#'     all functions return a descriptive report about the process made, that can be	
#'     also saved as data frame object. Although, the functions could be used in the	
#'     suggested pipelines, each function is suited to perform an specific task or a	
#'     set of them, given the package a high level of customization. See R-Alarcon	
#'     and Miranda-Esquivel (submitted).	
#' 	
#' ------	
#' 	
#' ## **1.0** A worked example for *geocleaMT* package (R-Alarcon and Miranda-Esquivel, submitted)	
#' 	
#' 	
#' ### *1.1* Preliminars	
#' 	
#' First, we remove everything to start with a clean session. If there is an open graphic device, we close it:	
#'   	
#'   	
#' 	
rm(list = ls())	
	
if (dev.cur() != 1){	
	dev.off()}	
#' 	
#' 	
#' 	
#' Then, we get the latest version of _**geocleaMT**_ from GitHub repository, and load the 	
#' library:	
#' 	
#' 	
#' 	
## You might need to uncomment these lines	
	
#install.packages(c('devtools', 'plyr', 'rgbif', 'RCurl', 'vegan', 'modeest', 	
#                    'maptools', 'data.table', 'RJOSONIO', 'reshape2'), 	
#                    dependencies = T, repos = 'https://www.icesi.edu.co/CRAN/')	



library('devtools')	
install_github('alarconvv/geocleaMT', dependencies = TRUE)	
library('geocleaMT')	
	
library('plyr')	
library('rgbif')	
library('RCurl')	
library('vegan')	
library('modeest')	
library('maptools')	
library('data.table')	
library('RJSONIO')	
library('reshape2')	
#' 	
#' 	
#' 	
#' Now we are ready to work. We must change our working directory to a suitable place, assuming you want to store your data/results in a directory called `~/geocleanMTtest/' in your home directory; first, we create it (if 	
#' exists there is no problem, just some warnings that we do not show): 	
#' 	
#' 	
#' 	
Sys.chmod(paths = '~/', mode = '7777', use_umask = TRUE)	
	
dir.create(path = '~/geocleanMTtest/', showWarnings = FALSE, recursive = FALSE, mode = '7777')	
	
pathToFiles <- '~/geocleanMTtest/'	
	
dir.create(path = pathToFiles, showWarnings = FALSE)	
	
setwd(pathToFiles)	
	
# To check everything is fine:	
	
getwd()	
#' 	
#' 	
#' 	
#' We create the directory structure to save the results in separated files. This 	
#' function will create a folder for each function used.	
#' 	
#' 	
#' 	
pathStructure(path.dir = '') 	
#' 	
#' 	
#' 	
#' If the protocol is performed for several groups, for example the classes: 	
#' Mammalia, Reptilia, etc., the user could assign these group names in the group 	
#' argument as c('Mammalia','Reptilia', 'Amphibia') to separate the results by group.	
#' 	
#' 	
#' 	
pathStructure(path.dir = '', group = 'Mammalia')	
#' 	
#' 	
#' 	
#' To obtain the occurrences reported for the Biogeographic Choco in the Global Biodiversity Information Facility (GBIF) (Telenius2011), we will go to GBIF website and follow the next pathway:	
#' 	
#' 	
#' ```	
#' >  Data	
#' >  Explore occurences (Fig. 1)	
#' ```	
#' 	
#' ![Figure 1. Explore occurences in GBIF](fig1.png)	
#' 	
#' Figure 1. Accessing to explore occurences in GBIF	
#' 	
#' ```	
#' >  Georeferenced records	
#' >  Add a filter	
#' >  Location (Fig. 2)	
#' ```	
#' 	
#' ![Figure 2. Georeferenced records](fig2.png)	
#' 	
#' Figure 2. Add the Location Filter	
#' 	
#' ```	
#' >  Location Box	
#' >  Draw tools: Undefined (Fig. 3)	
#' ```	
#' 	
#' ![Figure 3. Location and draw](fig3.png)	
#' 	
#' Figure 3. Drawing the polygon.	
#' 	
#' 	
#' Then, we draw the area of interest (in our case, The  Biogeographic Choco form (_sensu lato:_ Hernandez 1992), see Fig. 3), and click on:	
#' 	
#' ```	
#' > Apply	
#' ```	
#' 	
#' We will download a specific taxon using again the `add filter' tool. For example, we will download all occurrences of mammals reported by  GBIF for The  Biogeographic Choco (_sensu lato:_ Hernandez, 1992) (Fig. 3-4), as was used in the example in R-Alarcon and Miranda-Esquivel (submitted).	
#' 	
#' ![Caption for the picture.](fig4.png)	
#' 	
#' Figure 4. Add the scientific name filter.	
#' 	
#' 	
#' For this example, we will use a selection of 35 species from the 	
#' example in R-Alarcon and Miranda-Esquivel (submitted). These 35 species	
#' are the best candidates because they present all possible issues we can face in a standard dataset.	
#' 	
#' ```	
#' > Add Filter	
#' > Scientific name (Fig. 5)	
#' ```	
#' 	
#' ![Figure 5. Add Filter. Scientific name](fig5.png)	
#' 	
#' Figure 5. Applying the filter.	
#' 	
#' ```	
#' > Download (Fig. 6)	
#' ```	
#' 	
#' ![Figure 6. Download](fig6.png) 	
#' 	
#' Figure 6. Click on Download.	
#' 	
#' 	
#' The best file format to download is as a zip file, because it brings the complete information in the Darwin Core Standard (Wieczorek et al. 2012).	
#'  Keep in mind that you must be registered at  GBIF website.	
#' 	
#' After download the zip file, we have a folder with some information files. The file which have the occurrences data is the called `occurrences.text'. If you want to read it, note that the separator is TAB.	
#' 	
#' ### *1.2* The process	
#' 	
#' All the files imported or exported from _**geocleaMT**_ follow the headers	
#' proposed by the Darwin Core standard (Wieczorek et al. 2012), as it is used by GBIF.	
#' 	
#' 	
#' There are some functions that need to know the header names or the position of the column in the header. The code data('ID_DarwinCore') has the headers and the order as these are imported from GBIF.	
#' 	
#' 	
#' 	
data('ID_DarwinCore')	
	
str(ID_DarwinCore)	
#' 	
#' 	
#' 	
knitr::kable(head(ID_DarwinCore, 4L), format = 'markdown')	
#' 	
#' 	
#' ------	
#' 	
#' 	
#' ## **2.0** Get 35 Mammalian species distributed in the Biogeograpic Choco: Pipeline 1	
#' 	
#' 	
#' We can get the example file from the GitHub repository in the example folder, or we can write it from the data(example) object.	
#' 	
#' 	
#' 	
# we will get the example file from data(Example). 	
# If you downloaded it from GBIF, the file will in txt format.	
 	
data(Example)	

	
dir.create(path = 'data/', showWarnings = FALSE, recursive = FALSE, mode = '7777')	
	
readAndWrite(action = 'write', path = 'data/', frmt = 'saveTXT', 	
             name = 'Example.txt', object = Example)	
	
#' 	
#' 	
#' 	
#' We can see the structure, and some basic statistics of the input data, including the species' names.	
#' 	
#' 	
#' 	
str(Example)	
	
head(Example, 1L)	
	
levels(Example$species)	
#' 	
#' 	
#' 	
#' Now, we read the initial data set. As the file to load has fewer than 100.000 occurrences we use the  _**readDbR**_ function that is executed into the R platform. The function can use the columns names or the number of the ID assigned in data('ID_DarwinCore').	
#' 	
#' 	
#' 	
# Load the txt file 	
	
readDbR <- readDbR(data          = 'Example.txt',	
                   path.data     = 'data/' ,	
                   cut.col       = c('gbifID', 'decimalLatitude', 'decimalLongitude',	
                                     'elevation', 'speciesKey', 'species'),	
                   delt.undeterm = TRUE,	
                   save.name     = 'out.readDbR',	
                   wrt.frmt      = 'saveRDS',	
                   save.in       = 'readDbR/Mammalia/')	
	
#' 	
#' 	
#' 	
#' We get a table from the _**readDbR**_ function with the basic information as: initial occurrences, final occurrences and total species. When the **delt.undeterm** parameter is 'TRUE', the records without species taxonomy will be deleted, then the initial occurrences and final occurrences will be different, in this case all occurrences have species assigned.	
#' 	
#' 	
	
knitr::kable(readDbR, format = 'markdown')	
	
#' 	
#' 	
#' The output file will be saved in 'readDbR/Mammalia/' path:	
#' 	
#' 	
out.readDbR <- readAndWrite(action = 'read', path = 'readDbR/Mammalia/',	
                            frmt = 'readRDS', name = 'out.readDbR')	
	
	
# The structure and format of out.readDbBash will be the same than the input 	
# file 'Example.txt'	
	
str(out.readDbR) 	
#' 	
#' 	
#' 	
	
knitr::kable(head(out.readDbR), format = 'markdown')	
	
	
#' 	
#' 	
#' We will save the information as a table to record the cleaning process. The _**pathStructure**_ function created all the folders to follow the protocol, among those, the folder _'tables'_ to save this table of information.	
#' 	
#' 	
	
readAndWrite(action = 'write', frmt = 'saveTXT', path = 'tables/',	
             name = 'readDbR_example.txt', object = readDbR)	
	
#' 	
#' 	
#' When the file is larger than 100.000 occurrences, it could be difficult to read using _**readDbR**_. If this is the case, we can use the _**readDbBash**_ function to read large files. This process will be four times faster than with _**readDbR**_.	
#' 	
#' NOTE: As a bash process, the **cut.col** argument works with the ID number of the headers of the Darwin Core standard, see the number assigned in data('ID_DarwinCore').	
#' 	
#' In the case of a file downloaded from GBIF, the ID of Darwin core headers c(1, 78, 79, 200, 218, 219) correspond to: 'gbifID', 'decimalLatitude', 'decimalLongitude', 'elevation', 'speciesKey', 'species'. In this example the columns to use are c(1, 4, 5, 7, 11, 12).	
#' 	
#' 	
system <- Sys.info()["sysname"]	
if (!system == "Windows") {	
readDbBash <- readDbBash(data          = 'Example.txt',	
                         path.data     = 'data/',	
                         cut.col       = c(1, 4, 5, 7, 11, 12), 	
                         delt.undeterm = T,	
                         save.name     = 'out.readDbBash',	
                         wrt.frmt      = 'saveRDS',	
                         save.in       = 'readDbBash/Mammalia/')	
}	
#' 	
#' 	
#' Again, we write the output as a table to track the whole process.	
#' 	
#' 	
system <- Sys.info()["sysname"]	
if (!system == "Windows") {	
readAndWrite(action = 'write', frmt = 'saveTXT', path = 'tables/',	
             name = 'readDbBash_example.txt', object = readDbBash)	
}	
#' 	
#' 	
#' As our objective is to get species with occurrences into the elevation range 0 - 1000 MASL, then we can assign the elevation data to each coordinate from the elevation database 'Altitudes' (The elevation data was compiled from the Google Maps Elevation API). The average error is ~ 60m for 0-1000 MASL and ~ 150m for >1000 MASL (Fig. 7).	
#' 	
#' 	
#' 	
data('Altitudes')	

data(wrld_simpl)	
	
coordinates(Altitudes) <- Altitudes[, c('decimalLongitude', 'decimalLatitude')]	
	
par(oma = c(0,0,0,0), mar = c(0,0,0,0) + 0.1)	
	
plot(wrld_simpl, ylim = c(-10,15), xlim = c(-83,-73))	
	
points(Altitudes, pch = '.', col = 'grey', cex = 0.01 )	
	
# Figure 7. Coordinates with elevation data in data('Altitudes')	
#' 	
#' 	
#' We can assign the elevation using the _**assignAltitude**_ function. If the resolution in the elevation database used is 0.1, we should assign 1 in the **round.coord** argument. For example if the coordinate is Lat: 5.3456, Long: -74.2345 and the database is Lat: 5.3, Long: -74.2, elev: 856 MASL. Then the original coordinates will be rounded to Lat: 5.3, Long: -74.2 and 856 MASL will be assigned as the approximate elevation.	
#' 	
#' 	
data('Altitudes')	
	
assignAlt <- assignElevation(data = 'out.readDbR',	
                            path.data = 'readDbR/Mammalia/',	
                            rd.frmt = 'readRDS' ,	
                            elevations.db = Altitudes ,	
                            round.coord = 1,	
                            wrt.frmt = 'saveRDS',	
                            save.assigned.in = 'assignElevation/Mammalia/alt.assig/',	
                            save.unassigned.in = 'assignElevation/Mammalia/alt.unassig/')	
	
readAndWrite(action = 'write', frmt  = 'saveTXT' , path = 'tables/',	
             name = 'assignAltitude_example.txt', object = assignAlt)	
	
#' 	
#' 	
#' 	
knitr::kable(head(assignAlt), format = 'markdown')	
#' 	
#' 	
#' If there are unassigned points, we can assign the altitude using another elevation database or Google Maps Elevation API. When there are occurrences without elevation assigned from the _**assignAltitude**_ function, we can find them in the file: 'alt.unassigned', in the path of **save.unassigned.in** argument. 	
#' Thus, we can use the _**elevFromGg**_ function to get the altitude directly from Google Maps Elevation API. This process will be slower, and the API has a restriction, where you can only download around 2500 elevation points every 24 hours. More information about restrictions in: [developers.Google.com](https://developers.Google.com/maps/documentation/elevation/usage-limits).	
#' 	
#' 	
	
FromGg<-elevFromGg(data               = 'alt.unassigned',	
           rd.frmt            = 'readRDS',	
           path               = 'assignElevation/Mammalia/alt.unassig/',	
           API.Key            = NULL,	
           starts.in          = 1 ,	
           round.coord        = 4 ,	
           save.name          = 'alt.assigned',	
           wrt.frmt           = 'saveRDS',	
           save.assigned.in   = 'elevFromGg/Mammalia/alt.assig/' ,	
           save.unassigned.in = 'elevFromGg/Mammalia/alt.unassig/' ,	
           save.temp.in       = 'elevFromGg/Mammalia/')	


readAndWrite(action = 'write', frmt = 'saveTXT', path = 'tables/',
             name = 'FromGg_example.txt', object = FromGg)

knitr::kable(FromGg, format = 'markdown')

#' 	
#'  	
#' NOTE: If we get the message `Error in Call.API$results[[1]] :	
#' subscript out of bounds error', you must wait for 24 hours to access	
#' again the Google Maps Elevation API.	
#'  	
#'  	
#' When we have both tables with assigned elevation ('alt.assig' from _**assignAltitude**_ and 'alt.assig' from _**elevFromGg**_) we can bind them.	
#' 	
#' 	
# Read the tables	
	
assign1 <- readRDS('assignElevation/Mammalia/alt.assig/alt.assigned')	
assign2 <- readRDS('elevFromGg/Mammalia/alt.assig/alt.assigned')	
	
# Delete the last column called resolution to bind them	
	
assign2 <- assign2[, -7]	
	
# bind by columns 	
	
newassign <- rbind(assign1, assign2)	
	
# Write  the new table as an output file	
readAndWrite(action = 'write', frmt = 'saveRDS' , path = 'elevFromGg/Mammalia/alt.assig/',	
             name = 'completedElevation', object = newassign)	
	
#' 	
#' 	
#' We need to get species with occurrences in the elevation range from 0	
#' to 1000 MAMSL, then we use the _**cutRange**_ function.	
#' 	
#' 	
cutRange <- cutRange(data            = 'completedElevation' ,	
                     path            = 'elevFromGg/Mammalia/alt.assig/',	
                     rd.frmt         = 'readRDS',	
                     range.from      = 0,	
                     range.to        = 1000,	
                     wrt.frmt        = 'saveRDS',	
                     save.inside.in  = 'cutRange/Mammalia/inside/',	
                     save.outside.in = 'cutRange/Mammalia/outside/')	
	
readAndWrite(action = 'write', frmt = 'saveTXT', path = 'tables/',	
             name = 'cut_example.txt', object = cutRange)	
#' 	
#' 	
#' 	
knitr::kable(cutRange, format = 'markdown')	
#' 	
#' 	
#' Invasive species could bias the analysis in macroecology or biogeography, because their distribution do not correspond to their original or native distributions.	
#' 	
#' We use the _**invasiveSp**_ function to reduce this bias. This function is connected to the largest alien species databases (Island Biodiversity and Invasive Species (IBIS) (Kell and Worswick 1997) and Global Invasive Species 	
#' Database (GISD) (Lowe et al. 2000)).	
#' 	
#' 	

invasive <- invasiveSp(data                = 'inside.range',	
                       rd.frmt             = 'readRDS',	
                       path                = 'cutRange/Mammalia/inside/',	
                       starts.in           = 1,	
                       save.Sp.list        = TRUE,	
                       wrt.frmt            = 'saveRDS',	
                       save.foreign.in     = 'invasiveSp/Mammalia/foreign/',	
                       save.non.foreign.in = 'invasiveSp/Mammalia/non.foreign/',	
                       save.temp.in        = 'invasiveSp/Mammalia/')	
	
readAndWrite(action = 'write', frmt   = 'saveTXT', path   = 'tables/',	
             name   = 'invasive_Mammalia.txt', object = invasive)	
#' 	
#' 	
#' If the process is stopped, you can reset it using the last number reported in 	
#' console. You have to put this number in starts.in parameter as argument and the 	
#' process will restart in the position assigned.	
#' 	
#' NOTE: The foreign species are marked with a 1 symbol (TRUE), and the non foreign species with a 0.	
#' 	
#' 	
	
knitr::kable(invasive, format = 'markdown')	
	
#' 	
#' 	
#' Finally, we are done. Now we have the list of species to download from GBIF in the file 'input.rgbif.non.foreign', that can be found in 'invasiveSP/Mammalia/non.foreign/' path. 	
#' 	
#' 	
	
toDownload <- readAndWrite(action = 'read', frmt = 'readRDS',	
                           path = 'invasiveSp/Mammalia/non.foreign/',	
                           name = 'input.rgbif.non.foreign')	
	
str(toDownload)	
	
head(toDownload)	
	
#' 	
#' 	
#' ------	
#' 	
#' ## **3.0** Obtain species restricted to the Biogeographic Choco: Pipeline 2.	
#' 	
#' When we have the list of non-invasive species that inhabit on The Biogeographic Choco (**sensu lato**: Hernandez (1992)), we can download all occurrences for each species using the _**gbifDownSp**_ function. This function will save a file by species, thus if we decide to include or exclude species/records in the analysis, it would be easier to manipulate the files and perform the task.	
#' 	
#' The _**gbifDownSp**_ function works as a wrapper for the **occ_search** function from the _**rgif**_ package. You can use some additional parameters inherited from **occ_search** as **limit**, **basisOfRecord**, **country**, **publishingCountry**, **lastInterpreted**, **geometry**, **collectionCode**, **institutionCode** and **year**.	
#' 	
#' 	
# Read the list of species to download. It can be the output file of the 	
# invasiveSp function.	
	
input <- readAndWrite(action = 'read', frmt   = 'readRDS' ,	
                      path   = 'invasiveSp/Mammalia/non.foreign/',	
                      name   = 'input.rgbif.non.foreign')	
	
# Download the species	
	
gbifDownSp(sp.name          = input,	
           taxon.key        = NULL ,	
           genus            = NULL,	
           epithet          = NULL,	
           starts.in        = 1 ,	
           wrt.frmt         = 'saveRDS',	
           save.download.in = 'gbifDownSp/Mammalia/' ,	
           limit            = 200000)	
#' 	
#' 	
#' The occurrences reported by GBIF could be georeferenced or not. We can separate georeferenced from non georeferenced  using the _**splitGeoref**_ function.	
#' 	
#' The argument in the **data** parameter is a list of files to read, all files must be in the same format ('RDS' or 'TXT'). See the _**readAndWrite**_ function.	
#' 	
#' 	
#' 	
# create the list of files	
	
out.gbifDownSp <- list.files('gbifDownSp/Mammalia/')	
	
SplitGeoref <- splitGeoref(data             = out.gbifDownSp,	
                           rd.frmt          = 'readRDS',	
                           path             = 'gbifDownSp/Mammalia/' ,	
                           min.occ          = 3,	
                           round.coord      = 4,	
                           wrt.frmt         = 'saveRDS',	
                           save.min.occ.in  = 'splitGeoref/Mammalia/min.Occurren/',	
                           save.georef.in   = 'splitGeoref/Mammalia/georref/',	
                           save.ungeoref.in = 'splitGeoref/Mammalia/not.georref/')	
	
readAndWrite(action = 'write', frmt   = 'saveTXT', path   = 'tables/',	
             name   = 'splitGeoref_example.txt', object = SplitGeoref)	
#' 	
#' 	
#' 	
	
knitr::kable(head(SplitGeoref, 4L), format = 'markdown')	
	
#' 	
#' 	
#' The coordinates could be in different formats, but the unique valid format in this pipeline is decimal degree because we follow the Darwin Core Standard (Wieczorek 2012). Then, we test whether there are some errors with the coordinates format using the _**checkCoord**_ function. Additionally, this function can check the range of the coordinates (Long: -180, 180; Lat: -90, 90).	
#' 	
#' 	
#' 	
out.splitGeref <- list.files('splitGeoref/Mammalia/georref/')	
	
checkCoord(data          = out.splitGeref,	
           path          = 'splitGeoref/Mammalia/georref/',	
           rd.frmt       = 'readRDS',	
           wrt.frmt      = 'saveRDS',	
           save.right.in = 'checkCoord/Mammalia/right.coord/' ,	
           save.wrong.in = 'checkCoord/Mammalia/wrogn.coord/')	
	
#' 	
#' 	
#' We will check the georeferenced records downloaded from GBIF (Fig. 8). 	
#' 	
#' 	
#' 	
data('wrld_simpl')	
	
plot(wrld_simpl, border = 'grey50')	
	
georefFromGBIF <- list.files('checkCoord/Mammalia/right.coord/')	
	
for (i in 1:length(georefFromGBIF)) {	
  sp <- readRDS(paste('checkCoord/Mammalia/right.coord/', georefFromGBIF[i], sep = ''))	
  	
  coordinates(sp) <- sp[,c('decimalLongitude', 'decimalLatitude')]	
  	
  plot(sp, add = TRUE, pch = '*', col = 'green4')	
  }	
	
# Figure 8. Occurrences downloaded from GBIF, with geocode assigned.	
#' 	
#' 	
#' Sometimes the coordinates might have problems as wrong sign value, and as result we have coordinates of land species with occurrences at sea.	
#' 	
#' 	
out.checkCoord <- list.files('checkCoord/Mammalia/right.coord/')	
	
pointsAtSea <- pointsAtSea(data            = out.checkCoord ,	
                           path            = 'checkCoord/Mammalia/right.coord/',	
                           rd.frmt         = 'readRDS',	
                           wrt.frmt        = 'saveRDS',	
                           save.OnEarth.in = 'pointAtSea/Mammalia/on.earth/',	
                           save.AtSea.in   = 'pointAtSea/Mammalia/at.sea/')	
	
	
readAndWrite(action = 'write', frmt = 'saveTXT', path = 'tables/',	
             name = 'pointsAtSea_example.txt', object = pointsAtSea)	
#' 	
#' 	
#' 	
knitr::kable(head(pointsAtSea, 4L), format = 'markdown')	
#' 	
#' 	
#' Here, we can see the points at sea that were deleted in the last process (Fig. 9). 	
#' 	
#' 	
atsea <- list.files('pointAtSea/Mammalia/at.sea/')	
	
if (length(atsea) != 0 ) {	
  data('wrld_simpl')	
	
  plot(wrld_simpl, border = 'grey50')	
  	
  for (i in 1:length(atsea )) {	
    spAtSea <- readRDS(paste('pointAtSea/Mammalia/at.sea/', atsea[i], sep = ''))	
    	
    coordinates(spAtSea) <- spAtSea[,c('decimalLongitude','decimalLatitude')]	
    	
    plot(spAtSea,  add = T, pch = '*', col = 'green4')	
  }	
  	
  onEarth <- list.files('pointAtSea/Mammalia/on.earth/')	
  	
  for (i in 1:length(onEarth)) {	
    spOnEarth <- readRDS(paste('pointAtSea/Mammalia/on.earth/', onEarth[i], sep = ''))	
    	
    coordinates(onEarth) <- onEarth[,c('decimalLongitude','decimalLatitude')]	
    	
    plot(spOnEarth, add = T, pch = '*', col = 'orange')	
    	
    # Figure 9. Records at sea and on mainland.	
    }	
  }else{	
    cat('You do not have records at sea, your figure 9 will be equal to figure 8. \n')	
}	
#' 	
#' 	
#' We have downloaded species distributed on Choco, but some species could be widespread.	
#' We will use the function _**spOutPoly**_ in two steps: first, delete species distributed in others continents, either because the species are cosmopolitan or because the species is in other continent but the coordinates were placed in the area of interest because the sign was changed, for example a coordinate of an African species was positioned on America. In this case, we will perform the process at the continent level in a restricted form because the parameters: **max.per.out** and **max.occ.out** present low values and the conditions B1 an B2 are TRUE (See: R-Alarcon and Miranda-Esquivel (submitted)).	
#' 	
#' If the argument in the **execute** parameter is 'FALSE', the process will not classified the species and only will return a table of information that can be saved in your current work directory (See: getwd()). If **execute** is 'TRUE' the process will classified the species and the table of information can be the result of the function.	
#' 	
#' For example, when the execute argument is 'FALSE', we will find the table of information in the current working directory (getwd ()), this file will be called 'Classify.sp'.	
#' 	
#' 	
out.OnEarth <- list.files('pointAtSea/Mammalia/on.earth/')	
	
data('America')	

americaFilter <- spOutPoly(data            = out.OnEarth,	
                           rd.frmt         = 'readRDS' ,	
                           path            = 'pointAtSea/Mammalia/on.earth/',	
                           shp.poly        = America,	
                           max.per.out     = 10,	
                           max.occ.out     = 3,	
                           execute         = FALSE,	
                           B1              = TRUE,	
                           B2              = TRUE,	
                           wrt.frmt        = 'saveRDS',	
                           save.inside.in  = NULL ,	
                           save.outside.in = NULL)	
#' 	
#' 	
#' When we want to run the process we use execute = 'TRUE', then the table of information will be a vector data frame class assigned in 'americaFilter'. 	
#' This vector will be saved using readAndWrite as in previous functions.	
#' 	
#' 	
americaFilter <- spOutPoly(data            = out.OnEarth,	
                           rd.frmt         = 'readRDS' ,	
                           path            = 'pointAtSea/Mammalia/on.earth/',	
                           shp.poly        = America,	
                           max.per.out     = 10,	
                           max.occ.out     = 3,	
                           execute         = TRUE,	
                           B1              = TRUE,	
                           B2              = TRUE,	
                           wrt.frmt        = 'saveRDS',	
                           save.inside.in  = 'spOutPoly_America/Mammalia/inside/' ,	
                           save.outside.in = 'spOutPoly_America/Mammalia/outside/')	
	
readAndWrite(action = 'write', frmt = 'saveTXT', path = 'tables/',	
             name   = 'americaFilterExc_example.txt', object = americaFilter)	
#' 	
#' 	
#' 	
	
knitr::kable(head(americaFilter, 4L), format = 'markdown')	
	
#' 	
#' 	
#' Now we can see in green the distributions that were deleted, and in orange the distributions restricted to America (purple polygon).	
#' 	
#' 	
data("wrld_simpl")	
data('America')	
	
plot(wrld_simpl, border = 'grey50')	
	
plot(America, border = 'purple4', add = TRUE)	
	
onEarth <- list.files('pointAtSea/Mammalia/on.earth/')	
	
for (i in 1:length(onEarth)) {	
  spOnEarth <- readRDS(paste('pointAtSea/Mammalia/on.earth/', onEarth[i], sep = ''))	
  	
  coordinates(spOnEarth) <- spOnEarth[, c('decimalLongitude','decimalLatitude')]	
  	
  plot(spOnEarth, add = TRUE, pch = '*', col = 'green4')	
  	
}	
	
DistriAmerica <- list.files('spOutPoly_America/Mammalia/inside/')	
	
for (i in 1:length(DistriAmerica)) {	
  spDistriAmerica <- readRDS(paste('spOutPoly_America/Mammalia/inside/', 	
                                   DistriAmerica[i], sep = ''))	
  	
  coordinates(spDistriAmerica) <- spDistriAmerica[, c('decimalLongitude',	
                                                      'decimalLatitude')]	
  	
  plot(spDistriAmerica, add = TRUE, pch = '*', col = 'orange')	
}	
	
# Figure 10. Species distributed on the American continent.	
#' 	
#' 	
#' The second step is performed as a relaxed process, because the parameter values are more relaxed and the condition B1 and B2 is FALSE (B1F, B2F). See: R-Alarcon and Miranda-Esquivel (submitted).	
#' 	
#' 	
out.americFilter <- list.files('spOutPoly_America/Mammalia/inside/')	
	
data('ChcBiog')	

chocoFilter <- spOutPoly(data            = out.americFilter,	
                         rd.frmt         = 'readRDS' ,	
                         path            = 'spOutPoly_America/Mammalia/inside/',	
                         shp.poly        = ChcBiog,	
                         max.per.out     = 50,	
                         max.occ.out     = 10,	
                         execute         = TRUE,	
                         B1              = FALSE,	
                         B2              = FALSE,	
                         wrt.frmt        = 'saveRDS',	
                         save.inside.in  = 'spOutPoly_Choco/Mammalia/inside/' ,	
                         save.outside.in = 'spOutPoly_Choco/Mammalia/outside/')	
	
readAndWrite(action = 'write', frmt = 'saveTXT', path = 'tables/',	
             name = 'ChocoFilterExc_example.txt', object = chocoFilter)	
#' 	
#' 	
#' 	
knitr::kable(head(chocoFilter), format = 'markdown')	
#' 	
#' 	
#' We can see in orange the species restricted to The Biogeographic Choco.	
#' 	
#' 	
data('ChcBiog')	
data('America')	
plot(America, border = 'grey50')	
	
DistriAmerica <- list.files('spOutPoly_America/Mammalia/inside/')	
	
for (i in 1:length(DistriAmerica)) {	
  spDistriAmerica <- readRDS(paste('spOutPoly_America/Mammalia/inside/', 	
                                   DistriAmerica[i], sep = ''))	
  coordinates(spDistriAmerica) <- spDistriAmerica[, c('decimalLongitude', 'decimalLatitude')]	
  plot(spDistriAmerica, add = TRUE, pch = '*', col = 'green4')	
}	
	
plot(ChcBiog, border = 'red4', add = TRUE)	
	
DistriChoco <- list.files('spOutPoly_Choco/Mammalia/inside/')	
	
for (i in 1:length(DistriChoco)) {	
  spDistriChoco <- readRDS(paste('spOutPoly_Choco/Mammalia/inside/',	
                                 DistriChoco[i], sep = ''))	
  coordinates(spDistriChoco) <- spDistriChoco[, c('decimalLongitude', 'decimalLatitude')]	
  	
  plot(spDistriChoco, add = TRUE, pch = '*', col = 'orange')	
}	
  	
# Figure 11. Species distributed in the biogeographic Choco. 	
#' 	
#' 	
#' However some points are outside of Choco. This happens because in the last filter when the B1 or B2 was FALSE (B1F, B2F), the anomalous points outside of Choco were not deleted. Now we need to detect these points. We can use the 	
#' _**delPointsOrSp**_ function to delete the points/species outside the area, the filter is semi-automatic. 	
#' 	
#' For the parameters west = -120, east = -65, south = -25, north = 25, _**delPointsOrSp**_  will search coordinates less than -120 and higher than -65 on longitude, and less than -25 and higher than 25 on latitude.	
#' 	
#' In this case, for example the species _Saguinus oedipus_ presents a record in USA over 25 degrees, and the function will ask whether delete this point or delete the total distribution of this species. In our case we deleted the point.	
#' 	
#' NOTE: Until here, we could use all the processes in a single run, maybe as an Rscript, but the _**delPointsOrSp**_ function requires that user to decide whether delete some points or delete the total distribution of a species.	
#' 	
#' 	
#' 	
out.choco <- list.files('spOutPoly_Choco/Mammalia/inside/')	
	
delPointsOrSp <- delPointsOrSp(data         = out.choco,	
                               rd.frmt      = 'readRDS' ,	
                               path         = 'spOutPoly_Choco/Mammalia/inside/',	
                               west         = -120,	
                               east         = -65,	
                               south        = -25,	
                               north        = 25,	
                               plot.distrib = TRUE,	
                               wrt.frmt     = 'saveRDS',	
                               save.file    = 'delPointOrSp/Mammalia/') 	
#' 	
#' 	
#' 	
readAndWrite(action = 'write', frmt = 'saveTXT', path = 'tables/',	
             name = 'delPointsOrSp_example.txt', object = delPointsOrSp)	
#' 	
#' 	
#' 	
knitr::kable(head(delPointsOrSp), format = 'markdown')	
#' 	
#' 	
#' 	
#' We can delete the points when are asked:	
#' 	
#' ```	
#' [1] "Check the distribution: Saguinus oedipus"	
#' Delete points? 	
#'  (yes: y or not: n)= y	
#' 	
#' ```	
#' 	
#' or, we can delete the distribution of the species:	
#' 	
#' ```	
#' [1] "Check the distribution: Saguinus oedipus"	
#' Delete points? 	
#'  (yes: y or not: n)= n	
#'  Delete species? y	
#' 	
#' ```	
#' or we can delete nothing:	
#' 	
#' ```	
#' [1] "Check the distribution: Saguinus oedipus"	
#' Delete points? 	
#'  (yes: y or not: n)= n	
#'  Delete species? n	
#' 	
#' ```	
#' 	
#' 	
#' We can see a point over 25 decimal degrees, this point is deleted because it did not correspond to the distribution of the species. For this example, we kept the point over 25 decimal degrees.	
#' 	
#' NOTE: In Rmarkdown we can not deleted these anomalous points, but you could run the 'WorkedExample.R' code and  perform this complete process.	
#' 	
#' 	
#' 	
data('America')	
data('ChcBiog')	
par(oma = c(0,0,0,0), mar = c(0,0,0,0) + 0.1)	
	
plot(America, ylim = c(-50,50), xlim = c(-140,-30),  border = 'grey50')	
	
DistriChoco <- list.files('spOutPoly_Choco/Mammalia/inside/')	
	
for (i in 1:length(DistriChoco)) {	
  spDistriChoco <- readRDS(paste('spOutPoly_Choco/Mammalia/inside/', 	
                                 DistriChoco[i], sep = ''))	
  	
  coordinates(spDistriChoco) <- spDistriChoco[, c('decimalLongitude', 'decimalLatitude')]	
  	
  plot(spDistriChoco, add = TRUE, pch = '*', col = 'green4')	
}	
	
deltPoint <- list.files('delPointOrSp/Mammalia/')	
	
for (i in 1:length(deltPoint)) {	
  	
  spdeltPoint <- readRDS(paste('delPointOrSp/Mammalia/', deltPoint[i], sep = ''))	
  	
  coordinates(spdeltPoint) <- spdeltPoint[, c('decimalLongitude', 'decimalLatitude')]	
  	
  plot(spdeltPoint, add = TRUE,  pch = '*',  col = 'orange')	
  	
}	
	
plot(ChcBiog, border = 'red4', add = TRUE)	
abline(h = 25)	
abline(h = -25)	
abline(v = -120)	
abline(v = -65)	
	
# Figure 12. Occurrences that do not correspond to a chocoan species.	
#' 	
#' 	
#' After all the filters used, some species could have very few records. Thus, to define a polygon as an area of distribution we need at least 3 occurrences, then we will get species with a minimal number of occurrences using the _**usefulSp**_ function.	
#' 	
#' 	
out.deltpoints <- list.files('delPointOrSp/Mammalia/')	
	
usefulSp <- usefulSp(data = out.deltpoints,	
                     path = 'delPointOrSp/Mammalia/',	
                     cut.off = 3,	
                     rd.frmt = 'readRDS',	
                     wrt.frmt = 'saveRDS',	
                     save.useful.in = 'usefulSp/Mammalia/useful/',	
                     save.useless.in = 'usefulSp/Mammalia/useless/')	
	
readAndWrite(action = 'write', frmt   = 'saveTXT', path   = 'tables/',	
             name   = 'usefulSP_example.txt', object = usefulSp)	
#' 	
#' 	
#' 	
knitr::kable(head(usefulSp,4L), format = 'markdown')	
#' 	
#' 	
#' Now we prepare a single file with the data cleaned, and 'That's all folks'	
#' 	
#' 	
out.useful <- list.files('usefulSp/Mammalia/useful/' )	
	
stackSp <- stackSp(data            = out.useful,	
                   rd.frmt         = 'readRDS' ,	
                   path            = 'usefulSp/Mammalia/useful/',	
                   save.name       = 'stackSp_example' ,	
                   save.staking.in = 'stackingSp/',	
                   wrt.frmt        =  'saveRDS')	
#' 	
#' 	
#' 	
knitr::kable(stackSp,  format = 'markdown')	
#' 	
#' 	
#' We might want some information about the spatial distribution as a whole or by species. These metrics can be the mean propinquity, median propinquity, mode, skewness, etc.	
#' 	
#' For example, as a whole:	
#' 	
#' 	
# Remember to read the final file to perform the meanPropinquity process	
out.stackSp <- readAndWrite(action = 'read', frmt = 'readRDS' ,	
                      path = 'stackingSp/', name = 'stackSp_example')	
#' 	
#' 	
#' 	
#' 	
PropinquityWhole <- meanPropinquity(coord.table = out.stackSp,	
                                    calculatedBy = 'whole',	
                                    wrt.frmt    = 'saveTXT' ,	
                                    save.info.in = 'meanPropinquity/Mammalia/' ,	
                                    plot.dist    =  TRUE,	
                                    plot.onMap   = TRUE,	
                                    save.plot.in = 'meanPropinquity/Mammalia/')	
	
#' 	
#' 	
	
knitr::kable(head(PropinquityWhole),  format = 'markdown')	
	
#' 	
#' 	
#' 	
#' or by species:	
#' 	
#' 	
PropinquitySp <- meanPropinquity(coord.table    = out.stackSp ,	
                                 calculatedBy = 'species',	
                                 wrt.frmt     = 'saveTXT' ,	
                                 save.info.in = 'meanPropinquity/Mammalia/' ,	
                                 plot.dist    =  TRUE,	
                                 plot.onMap   = TRUE,	
                                 save.plot.in = 'meanPropinquity/Mammalia/')	
	
#' 	
#' 	
#' 	
	
knitr::kable(head(PropinquitySp, 4L),  format = 'markdown')	
	
#' 	
#' 	
#' The information table and the density plot with the descriptors can be seen in 'meanPropinquity/Mammalia/' path.	
#' 	
#' 	
#' ![Figure 13. Mean propinquity](plotDistWhole.jpeg)	
#' 	
#' 	
#Figure 13. Informative plot: 'As a whole'.	
#' 	
#' 	
#' 	
#' DENSITY PLOT LEGEND ::::	
#' 	
#' RED: Mean Propinquity	
#' 	
#' YELLOW: Median Propinquity	
#' 	
#' BLUE: Mode Propinquity	
#' 	
#' Finally, We also could convert between formats using the _**readAndWrite**_ function, For example from R objet ('RDS') to plain text ('TXT'), so we could read this with any program.	
#' 	
#' 	
finalFile <- readAndWrite(action = 'read', frmt = 'readRDS' ,	
                          path = 'stackingSp/', name = 'stackSp_example')	
	
	
	
readAndWrite(action = 'write', frmt = 'readRDS' , path = '', 	
             name = 'finalFile_example', object = finalFile)	
#' 	
#' 	
#' The final file looks like:	
#' 	
#' 	
	
head(finalFile, 1L)	
	
#' 	
