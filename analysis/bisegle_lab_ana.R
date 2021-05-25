library(psych)
library(MASS)
library(gtools)

rm(list=ls())
source("~/R/bisegle/prf functions.R")
source("~/R/bisegle/remove.repeats.R")
source("~/R/bisegle/helper.R")

d <- read.csv("~/R/bisegle/data/bisegle_4.16.09_nonan.csv",colClasses = "character")

two.rs = apply(d[,4:14],1,two.recall)
two.ps = apply(d[,4:14],1,two.precision)
three.rs = apply(d[,4:14],1,three.recall)
three.ps = apply(d[,4:14],1,three.precision)
two.f = apply(cbind(two.ps,two.rs),1,na.harmonic.mean)
three.f = apply(cbind(three.ps,three.rs),1,na.harmonic.mean)

twof = by(two.f,d$subject,mean)
threef = by(three.f,d$subject,mean)
cond = by(d$repetition.cond,d$subject,unique)

pdf("~/Desktop/bisegle tex/figures/bisegle_lab.pdf",width=4,height=4)

cols = c("red","blue","orange")
pchs = c(15,16,17)
plot(twof,threef,
	xlab="F-score for two-segmentation",
	ylab="F-score for three-segmentation",
	pch=pchs[cond],col=cols[cond],
	bty="n",xlim=c(0,1),ylim=c(0,1),xpd="n",
	xaxp=c(0,1,2),yaxp=c(0,1,2))
legend(.8,1,c("1x","2x","4x"),col=cols,pch=pchs)

dev.off()
	