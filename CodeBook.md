CookBook...
Abstract
--------
	run_analysis program gets tidy dataset from train and test directories, also generates average for each of these columns in a different file. This program creates a couple of files each time it has been executed successfully.
	run_analysis program  tries to do a non-expensive memory usage it means that this program reads line by line from each file to avoid overload computer memory.

General Program Description
---------------------------
	run_analysis program performs following steps:
		1.- Provides three optional parameters 
			a)dataPath- default dataset directory, if current directory contains train and test directories just provide "." value for this parameter  
			b)outputType- file extension type csv/txt
			c)quiet- enable to show detailed processing information
		2.- Looks for the features.txt file and dataset directories if any of these is not found it will send a warning and the program ends.
		3.- Read features.txt file to get column number and name, then selects those rows that contain in their column name "Mean, "mean" and "std" string values in their names. These valueas area stored in colSelNums and colSelTitles vectors.
		4.- Reads files in train and test directories using a loop cycle, first loop cycle will read train's file, second loop cycle will read test's file so we avoid duplicated code
			a) fileconx establishes a read connection with the X_t???.txt file
			b) Read number of lines for the X_t???.txt file in order to provide a progress status in case it might be requested by the user, these number is stored in the numberOfLines variable
			b) fileconx is closed
			c) fileconx1 establishes a read connection with the X_t???.txt file 
			d) Append row by row selected information (columns are selected in colSelNums) and stored into the tidyDF data frame 
			e) if quiet parameter is TRUE  run_analysis shows progress of this process
			f) fileconx1 file connection is closed
		5.- Sets column names for tidy data frame using  colSelTitles vector
		6.- Once two cycles were finished run_analysis program gets column average store this into avgDF variable using colMeans R function.
		7.- Gets time stamp to append this to the file name in this way you might get several files without overwriting them each time you executes this program.
		8.- Create output files depending on chosen format by user in outputType. 
			a) tidyDataSet- file contains information from train and test 
			b) tidyAverage- file contains average information for each columns
			
Detailed Program Description
----------------------------
Program will get relative/full path depending on where the program is stored. This program should be stored in the root path (at same level that "UCI HAR Dataset" directory is).
featuresFPath, trainFPath, and testFPath variables contains path and file names to get column names, and dataset files. The full/relative path is concatenated along with the file names in order to get column names, and dataset files:
	  featuresFPath<-paste(dataPath,"/","features.txt", sep="");
	  trainFPath<-paste(dataPath,"/train/X_train.txt", sep="");
	  testFPath<-paste(dataPath,"/train/X_train.txt", sep="");
Program looks for features.txt file, train, and test directories. If these are not found, the program will raise a warning asking to store the program at the same level where UCI HAR Dataset directory is. 
	  if (file.exists(featuresFPath) & file.exists(trainFPath) & file.exists(testFPath))
	  { ..... }
	  else {
		warning("feature.txt file, train, and test directories were not found. Please provide full/relative path to get these files.", call. = FALSE)	  }

Read features.txt file to get column numbers and their respective column names into two list then set this information to a data frame (columnsInDF -columns in Data frame-) first column contains numeric column number (colNumber) and the second one contains the column title (colTitle). Note that to get these columns names program uses scan instead of reading line by line... this is because features.txt is a small file that does not requires big amounts of memory.
	
	columnsInDF<-data.frame(scan(featuresFPath, what=list(colNumber=numeric(0),colTitle=character(0))))
Create a data frame sub-setting from the file with the columns numbers that contains "Mean", "mean" and "std" values
	selectedCols<-subset(columnsInDF,select=c(1,2),subset=(grepl("ean",columnsInDF$colTitle) | grepl("std",columnsInDF$colTitle)))	
Create two vectors: colSelNums contains column numbers that I will use to extract required columns, and colSelTitles that contains their respective column title. These two vectors will be used as columns selection and columns names.	
	colSelNums<-selectedCols[,1]
	colSelTitles<-as.character(selectedCols[,2])

		
One important aspect analysing information from files is the size of it, so the program gets elements line by line using scan from the features.txt file in order to avoid any memory overloading before to end full processing of it
it will get and store in a numeric vector 561 elements per line (I applied same strategy to get information for the dataset files). 
		
This will be accomplished using a loop through the file.
	for (loopNum in 1:2)
	{
		if (loopNum==1) currProcessingFile<-trainFPath;
		if (loopNum==2) currProcessingFile<-testFPath;

Read line by line first to get number of lines for each file then to get data information
	for(i in 1:numberOfLines) {
			completeLine <- scan(file =fileconx1, what=numeric(0), nlines=1, quiet=TRUE);
			numLinesRead<-numLinesRead+1;
Append row by row selected information using rbind funtion and using the colSelNums vector that contains required column numbers 
			tidyDF<-rbind(tidyDF,completeLine[colSelNums]);
Set column names for tidy data frame
	colnames(tidyDF)<-colSelTitles;
Get column average and specify number of columns using length() function
	avgDF<-data.frame(matrix(colMeans(tidyDF, na.rm = FALSE),ncol=length(colSelNums)));
Sets column names for average data frame
	colnames(avgDF)<-colSelTitles;
Create output in current directory file depending on chosen format by user (csv/txt) 
	if (grepl(outputType,"csv")) 
	{
		filename<-paste("tidyDataSet-",dt,".csv",sep="");
		write.csv(tidyDF, file = filename, row.names = FALSE);
		filename<-paste("tidyAverage-",dt,".csv",sep="");
		write.csv(avgDF, file = filename, row.names = FALSE);

That's it!!!
Kind regards	
	
	