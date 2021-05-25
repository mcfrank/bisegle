library(plotrix)
rm(list=ls())

data <- read.csv("~/R/bisegle/data/fggt_2afc_data_noortho.csv")
source("~/R/bisegle/remove.repeats.R")
data <- remove.repeats(data)
ntrials = 24

## for each worker
corrs <- matrix(nrow=length(data$WorkerId),ncol=ntrials)
for (s in 1:length(data$WorkerId)) {
   
  for (i in 1:ntrials) {
    resp <- eval(parse(text=paste("data$Answer.answer",
                         as.character(i),"[",as.character(s),"]",sep="")))
    corr <- eval(parse(text=paste("data$Input.correct",
                         as.character(i),"[",as.character(s),"]",sep="")))
    corrs[s,i] <- resp==corr
  }
}

expt2 <- read.table("~/matlab/goldwater/expts/data/SSN2-data.txt",
	header=FALSE,sep='\t',	
	col.names=c("name","cond","date","len","rt","resp","corr","null"))
submeans <- by(expt2$corr[expt2$cond==300],expt2$name[expt2$cond==300],mean)

subs <- matrix(nrow=60,ncol=3)
subs[1:24,2] <- rowMeans(corrs,na.rm=TRUE)
subs[1:12,1] <- as.numeric(submeans)[!is.na(submeans)]

# data from frequency balanced replication
subs[,3] <- c(0.75,0.67,0.83,0.83,0.75,0.79,0.75,1.00,0.83,0.96,0.58,0.58,0.75,0.92,0.71,0.71,0.67,0.79,0.71,0.71,0.79,0.79,0.67,0.54,0.67,0.75,0.96,0.54,0.79,0.88,0.88,0.67,0.83,0.79,0.67,0.79,0.79,0.62,0.79,0.92,0.38,0.58,0.67,0.33,0.75,0.79,0.75,1.00,0.75,0.79,0.96,0.79,0.58,0.96,0.88,0.50,0.62,0.67,0.67,0.75)
       
subs <- data.frame(subs)
names(subs) <- c("Lab","Turk 1","Turk 2")

# read in the segmentation task data 
#source("~/R/bisegle/fggtana.R")
#names(bysub) <- c("Precision","Recall","F")

# create the composite plot
#pdf("~/Desktop/bisegle tex/figures/2afc.pdf",width=4,height=4)
#layout(matrix(c(1,2), 1, 2, byrow = TRUE))

stripchart(subs*100,
	vertical=TRUE,method="stack",offset=.5,pch=20,
	ylim=c(0,100),yaxp=c(0,100,4),xlim=c(.6,4),ylab="Percent correct",xlab="Subject group")
points(.9:2.9,colMeans(subs,na.rm=TRUE)*100,pch="-",col="red",cex=3.5)
lines(c(0,4.5),c(50,50),lty=2,col="black")
#title("2AFC Response")
#dev.off()
	
#pdf("~/Desktop/bisegle tex/figures/seg.pdf",width=4,height=4)
stripchart(round(bysub*20)/20,vertical=TRUE,method="stack",offset=.5,pch=20,
	ylim=c(0,1),yaxp=c(0,1,4),xlim=c(0.4,3.6),ylab="Score",xlab="Evaluation measure")
#title("Segmentation Response")	
points(.8:2.8,means,col="black",pch="-",cex=1.5)
lines(c(.5,1.5),c(rand.means[1],rand.means[1]),lty=2,col="black")
lines(c(1.5,2.5),c(rand.means[2],rand.means[2]),lty=2,col="black")
lines(c(2.5,3.5),c(rand.means[3],rand.means[3]),lty=2,col="black")
#plotCI(.8:2.8,rand.means,rand.cis[2,] - rand.means,
 #      rand.means - rand.cis[1,],pch="-",add=TRUE)

dev.off()

t.test(bysub[,1]-rand.means[1])
t.test(bysub[,2]-rand.means[2])
t.test(bysub[,3]-rand.means[3])