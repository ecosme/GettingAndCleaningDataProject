GettingAndCleaningDataProject
=============================

Contains course project to get tidy data from mobile tracking information

run_analysis uses three optional parameters
	run_analysis(a,b,c)
		a)dataPath- default dataset directory, if current directory contains train and test directories just provide "." value for this parameter  
		b)outputType- file extension type csv/txt
		c)quiet- enable to show detailed processing information

	examples of usage:
		run_analysis(".")
			---program will use current directory to look for features.txt file train and test directories 
		run_analysis(".", "csv")
			---program will use current directory to look for features.txt file train and test directories and it will create output file using csv tab file
		run_analysis(".", "csv", TRUE)
			---program will use current directory to look for features.txt file train and test directories, it will create output file using csv tab file, and it will show processing percentage process.
tidyDS- file contains train and test dataset in only one file, this file contains only required information (mean and std columns)

tidyAverage- contains average for each column 