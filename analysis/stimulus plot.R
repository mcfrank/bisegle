

tps <- c(0.5621,0.6520,0.6732,0.6915,0.5504,0.9039,0.5525,0.6698,0.6949,0.7258,0.5564)

pdf("~/Desktop/bisegle tex/figures/ex.pdf",width=5.4,height=3.5)
plot((1:11)+.5,1-tps,type="l",ylab="transitional probability",xlim=c(1,12),
	xlab="syllable position",xaxp=c(1,12,11),yaxp=c(0,.5,2),
	ylim=c(0,.5))
dev.off()
