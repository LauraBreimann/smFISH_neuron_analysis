// Define input and output folders as well as image type
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix


processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	
	// open file
	open(input + File.separator + file);
	print("Processing: " + input + File.separator + file);
	
	//convert to mask
	run("Threshold...");
	setAutoThreshold("Otsu");
	setThreshold(1, 2, "raw");
	setOption("BlackBackground", false);
	run("Convert to Mask");

	
	run("Measure");
	updateResults();
	//run("Close");
	
	
	
	//get the area pixels of the mask
	//getStatistics(area);
	//getValue("Area");
	//setResult("Area", file, area);
	
	//save results of the mask size
	print("Saving to: " + output);
	saveAs("results", output + File.separator + file + ".csv");	
	run("Clear Results");
	close();

	
	
}



run("Close All");
run("Close All");
run("Close All");
run("Close");

