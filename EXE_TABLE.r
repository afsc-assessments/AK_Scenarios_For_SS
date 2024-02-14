EXE_TABLE<-function(profiles=profile, URL="https://apps-afsc.fisheries.noaa.gov/Plan_Team/2022/EBSpcod.pdf"){
# Load libraries
  library(pdftools)
  library(tabulizer)
  library(data.table)
  library(r4ss)
  library(dplyr)
  library(flextable)

#' create the main safe table function
## main table for tier 3 canabalized from Ben's SAFE library 

## pull data from old assessment table
  url<-URL
  syr <- profiles$Tables$SSB$Yr[1]
  download.file(url, destfile = "document.pdf", mode = "wb")
  # Extract tables from the PDF
  tables2 <- tabulizer::extract_tables("document.pdf")
  test2<-vector("list",length(tables2))

  ## suppressing warnings on introduded NAs
  suppressWarnings({
    split_str <- strsplit(tables2[[1]][3:22,2], split = " ")
    split_str[[15]]<-c("NA","NA")
    split_str <- do.call(rbind, split_str)

    split_str2 <- strsplit(tables2[[1]][3:22,3], split = " ")
    split_str2[[15]]<-c("NA","NA")
    split_str2 <- do.call(rbind, split_str2)
  

  MANG_TABLE<-data.table::data.table(Quantity=tables2[[1]][c(3:18,20:22),1],matrix(ncol=2,as.numeric(gsub(",", "", gsub("\\*", "",split_str)))),matrix(ncol=2,as.numeric(gsub(",", "", gsub("\\*", "",split_str2)))))
  names(MANG_TABLE)<-c("item","y1","y2","y3","y4")

  MANG_TABLE<-data.frame(MANG_TABLE)

  # Define the columns to be updated
  cols <- 2:5

  # Define the source matrices and their corresponding columns
  sources <- list(split_str, split_str2)
  source_cols <- list(c(1, 2), c(1, 2))

  MANG_TABLE[c(3,17:19), cols] <- unlist(lapply(seq_along(cols), function(i) {
    sources[[((i - 1) %/% 2) + 1]][c(3,17:19), source_cols[[((i - 1) %/% 2) + 1]][(i - 1) %% 2 + 1]]
  }))

  ## putting in commas in large numbers
  rows=c(4:8,12:14)
  rnd<-function(x,data=MANG_TABLE){formatC(as.numeric(data[x,2:5]),format="f",big.mark=",",digits=0)}

  for(i in rows){
   MANG_TABLE[i,2:5]<-rnd(i)
  }  

  MANG_TABLE$y1<-MANG_TABLE$y3
  MANG_TABLE$y2<-MANG_TABLE$y4


  ## setting last 2 years to correct values from the profile object

  MANG_TABLE[4,4:5]=formatC(profiles$SSB[model=='scenario_2'&Yr%in%c(syr+1,syr+2)]$TOT,format="f",big.mark=",",digits=0)
  MANG_TABLE[5,4:5]=formatC(profiles$Two_year$SSB,format="f",big.mark=",",digits=0)
  MANG_TABLE[6,4:5]=formatC(profiles$Two_year$SB100,format="f",big.mark=",",digits=0)
  MANG_TABLE[7,4:5]=formatC(profiles$Two_year$SB40,format="f",big.mark=",",digits=0)
  MANG_TABLE[8,4:5]=formatC(profiles$Two_year$SB35,format="f",big.mark=",",digits=0)
  MANG_TABLE[9,4:5]=formatC(profiles$Two_year$F35,format="f",big.mark=",",digits=2)
  MANG_TABLE[10,4:5]=formatC(profiles$Two_year$F40,format="f",big.mark=",",digits=2)
  MANG_TABLE[11,4:5]=formatC(profiles$Two_year$F40,format="f",big.mark=",",digits=2)
  MANG_TABLE[12,4:5]=formatC(profiles$Two_year$C_OFL,format="f",big.mark=",",digits=0)
  MANG_TABLE[13,4:5]=formatC(profiles$Two_year$C_ABC,format="f",big.mark=",",digits=0)
  MANG_TABLE[14,4:5]=formatC(profiles$Two_year$C_ABC,format="f",big.mark=",",digits=0)


  catch1 <- formatC(profiles$Tables$Catch$scenario_2[1:3],format="f",big.mark=",",digits=0)

  ## creating main table

  EXE_TABLE<-main_table(MANG_TABLE[2:19,], year=syr, tier=3, c1=catch1[1], c2=catch1[2], c3=catch1[3])
  })
  
  EXE_TABLE
}

