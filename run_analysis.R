run_analysis<-function(dataPath="UCI HAR Dataset", outputType="csv", quiet = FALSE)
{
  featuresFPath<-paste(dataPath,"/","features.txt", sep="");
  trainFPath<-paste(dataPath,"/train/X_train.txt", sep="");
  testFPath<-paste(dataPath,"/test/X_test.txt", sep="");

  #look for the features.txt file and dataset directories...
  if (file.exists(featuresFPath) & file.exists(trainFPath) & file.exists(testFPath))
  {
	#Gets column number and name, and select those rows that contain [Mm]ean and std string values in their names
	print("Processing Analysis Started... Getting columns information...");
    columnsInDF<-data.frame(scan(featuresFPath, what=list(colNumber=numeric(0),colTitle=character(0))));
	selectedCols<-subset(columnsInDF,select=c(1,2),subset=(grepl("ean",columnsInDF$colTitle) | grepl("std",columnsInDF$colTitle)));
	colSelNums<-as.numeric(selectedCols[,1]);
	colSelTitles<-as.character(selectedCols[,2]);
	#Read train and test files in same code section nevertheless first loop cycle will read train's file 
	# second loop cycle will read test's file so we avoid duplicated code 
	for (loopNum in 1:2)
	{
		if (loopNum==1) currProcessingFile<-trainFPath;
		if (loopNum==2) currProcessingFile<-testFPath;
		  #Open file connection in order to count number of lines for the file
		  fileconx <- file(description=currProcessingFile,open="r");
		  #Set initial memory size
		  readSizeof <- 20000;
		  numberOfLines <- 0;
		  print(paste("Preliminary file reading process for ", currProcessingFile, " please wait..."));
		  ( while((linesread <- length(readLines(fileconx,readSizeof))) > 0 ) 
			numberOfLines <- numberOfLines+linesread )
		  
		  close(fileconx);
		  numLinesRead<-0;
		  tidyDF<-numeric();
		  #Read line by line to get selected columns
		  fileconx1 <- file(description=currProcessingFile,open="r");
		  print(paste("Initializing file reading process for ", currProcessingFile, " please wait..."));
		  for(i in 1:numberOfLines) {
			completeLine <- scan(file =fileconx1, what=numeric(0), nlines=1, quiet=TRUE);
			numLinesRead<-numLinesRead+1;
			#Append row by row selected information
			tidyDF<-rbind(tidyDF,completeLine[colSelNums]);
			#Show progress of this process
			if (!quiet) cat(paste("*",(sprintf("%3.2f %% ", ((numLinesRead/numberOfLines)*100))),"*",sep=""));
		  }
		  close(fileconx1);
	}
	#Set column names for tidy data frame
	colnames(tidyDF)<-colSelTitles;

	#Get column average
	avgDF<-data.frame(matrix(colMeans(tidyDF, na.rm = FALSE),ncol=length(colSelNums)));
	colnames(avgDF)<-colSelTitles;
	
	#Getting timestamp to append this to the file name in this way you might get several files without overwriting them
	dt<-gsub(" ","_",gsub(":","",Sys.time()));
	print("Creating output file in current directory...");
	#Create output file depending on chosen format by user
	if (grepl(outputType,"csv")) 
	{
		filename<-paste("tidyDataSet-",dt,".csv",sep="");
		write.csv(tidyDF, file = filename, row.names = FALSE);
		filename<-paste("tidyAverage-",dt,".csv",sep="");
		write.csv(avgDF, file = filename, row.names = FALSE);
	}
	else
	{
		filename<-paste("tidyDataSet-",dt,".txt",sep="");
		write.table(tidyDF, filename, sep="\t", row.names=FALSE, col.names=TRUE);
		filename<-paste("tidyAverage-",dt,".txt",sep="");
		write.csv(avgDF, file = filename, row.names = FALSE);		
	}
	print("Process successful, please look for tidyDataSet and tidyAverage files in current directory...");
	print("Process finished!!!!!");
  }
  else
  {
    warning("feature.txt file or train, or test directories were not found. Please provide full/relative path to get these files.", call. = FALSE)
  }
}