remove.repeats <- function(data) {

data <- data[!is.na(data$Answer.answer1),]

data$SubmitTimePosix <- rep(as.POSIXct(NA),length(data$SubmitTime))
for (i in 1:length(data$SubmitTime)) {
	data$SubmitTimePosix[i] <- as.POSIXct(as.character(data$SubmitTime[i]),
				format="%a %b %d %H:%M:%S GMT %Y")
}

# get rid of the second time for participants who did the task more than once
i = 1
subs <- unique(data$WorkerId)

while (i < length(subs)) {
	subs <- unique(data$WorkerId)

	ind <- data$WorkerId==subs[i]
	if (sum(ind) > 1) {
		times <- data$SubmitTimePosix[ind]
		times <- sort(times)
		for (j in 2:length(times)) {	
			data <- data[data$SubmitTimePosix != times[j],]
			subs <- subs[data$SubmitTimePosix != times[j]]		}
	}
	i = i + 1;
}

# get rid of null participants
i = 1
while (i < length(data$WorkerId)) {
	if (data$Answer.answer1[i] == "00000000000" && data$Answer.answer2[i] == "00000000000") {
		ind = rep(TRUE,length(data$WorkerId))
		ind[i] = FALSE
		data <- data[ind,]
	} else {
		i = i + 1
	}	
}

return(data)

}

d.to.data <- function(d) {
	n <- length(d$WorkerId)
	data <- data.frame(matrix(nrow=n*10,ncol=2))
	names(data) <- c("subnum","resp")
	c = 1
	for (i in 1:n) {
		for (j in 1:10) {
			resp <- eval(parse(text=paste("d$Answer.answer",
				as.character(j),"[",as.character(i),"]",sep="")))
			data$subnum[c] <- i
			data$resp[c] <- resp
			c = c + 1
		}	
	}
return(data)
}