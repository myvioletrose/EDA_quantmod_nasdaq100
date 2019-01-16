### set wd
setwd("C:/Users/traveler/Desktop/Jim/# R/# analytics/quantmod")

### load packages
library(quantmod)
library(rlang)
library(plyr)
library(tidyverse)
library(plotly)
library(MASS)

### NASDAQ-100
n100 <- c("AAL, AAPL, ADBE, ADI, ADP, ADSK, ALGN, ALXN, AMAT, AMGN, AMZN, ASML, ATVI, AVGO, BIDU, BIIB, BKNG, BMRN, CDNS, CELG, CERN, CHKP, CHTR, CMCSA, COST, CSCO, CSX, CTAS, CTRP, CTSH, CTXS, DISH, DLTR, EA, EBAY, ESRX, EXPE, FAST, FB, FISV, FOX, FOXA, GILD, GOOG, GOOGL, HAS, HOLX, HSIC, IDXX, ILMN, INCY, INTC, INTU, ISRG, JBHT, JD, KHC, KLAC, LBTYA, LBTYK, LRCX, MAR, MCHP, MDLZ, MELI, MNST, MSFT, MU, MXIM, MYL, NFLX, NTES, NVDA, ORLY, PAYX, PCAR, PYPL, QCOM, QRTEA, REGN, ROST, SBUX, SHPG, SIRI, SNPS, STX, SWKS, SYMC, TMUS, TSLA, TTWO, TXN, ULTA, VOD, VRSK, VRTX, WBA, WDAY, WDC, WYNN, XLNX, XRAY")

one_quote <- paste(unlist(n100), collapse = ", ") %>%
        # write.csv(., "clipboard", row.names = F) %>%
        stringr::str_split(., pattern = ", ") %>%
        unlist %>%
        print

# get symbols
start <- Sys.time()
getSymbols(one_quote)
end <- Sys.time()
end - start

# create a function to unwrap 
unwrap <- function(x) {
        var <- sym(x)
        df <- eval(var)
        df
}

obj <- vector(length = length(one_quote), mode = "list") 
length(obj)  # [1] 103 

# get the list
for(i in 1:length(one_quote)){
        obj[[i]] <- unwrap(one_quote[i])
}

# generate the chart
cs.start <- Sys.time()
old.dir <- getwd()

if( "latest_quantmod_chart" %in% dir() ) {
        unlink(x = "latest_quantmod_chart", recursive = T)
}

dir.create(paste(old.dir, "/latest_quantmod_chart", sep = ""))
setwd("./latest_quantmod_chart")

for(i in 1:length(one_quote)){
        name <- paste(one_quote[i], "_", "201807_YTD", ".png", sep = "")
        png(filename = name, width = 900, height = 660)
        x <- xts(obj[[i]])
        chartSeries( x["201807::"], TA = c(addBBands(draw = 'bands'), 
                                         addBBands(draw = 'width'),
                                         addBBands(draw = 'percent'),
                                         addCCI(),
                                         addADX(),
                                         addCMF(),
                                         addVo()) )
        dev.off()
}

setwd(old.dir)
cs.end <- Sys.time()
cs.end - cs.start


#####################################
# windows()
# chartSeries( CELG["201701::201712"], TA = c(addBBands(draw = 'bands'), 
#                                  addBBands(draw = 'width'),
#                                  addBBands(draw = 'percent'),
#                                  addCCI(),
#                                  addADX(),
#                                  addCMF(),
#                                  addVo()) )

# # plotly example, can we do something (add_surface()) with quantmod data?
# kd <- with(MASS::geyser, MASS::kde2d(duration, waiting, n = 50))
# p <- plot_ly(x = kd$x, y = kd$y, z = kd$z) %>% add_surface()
# p









