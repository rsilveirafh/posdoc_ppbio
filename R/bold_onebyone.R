bold_onebyone <- function(data, species) {

	# loading required packages
	require(bold)

	# creating temporary null data.frame
	tmp <- data.frame()

	# error
	e <- simpleError("Error")

	# starting the loop
	for (i in 1:nrow(data)){

		# wait one second before another search
		Sys.sleep(1)

		# declaring the species variable
		sp <- as.character(data[i, species])

		cat("\nSpecies", sp, ", number", i)

		# tryCatch the results
		attempt <- tryCatch({
			bold::bold_seqspec(taxon = sp)
		},
		error = function(e) {}
		)

		# check if the attempt is a data frame
		if (inherits(attempt, "data.frame")) {
		   
		     # gather results
		    tmp <- rbind(tmp, attempt)
		}

	}

	return(tmp)

}






