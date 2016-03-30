args = commandArgs(trailingOnly=TRUE)
out <- paste(args[1],".txt",sep="")
sink(out, type = c("output", "message"))

# install needed packages
install.packages(pkgs=c("plyr","gdata","knitr","markdown","rjags","coda"), quiet=T)

# jags run
modelBuild <- "/home/MAPPPD-Model/ModelBuild/"
wd <- paste(modelBuild,args[1],sep="")
setwd(wd)
file <- paste(args[1],".R",sep="")
source(file, verbose=TRUE)

sink()
