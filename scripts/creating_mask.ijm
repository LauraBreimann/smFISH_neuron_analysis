//===============================================================================
// Creates a binary mask from a ilastik output tiff file
//  - Laura Breimann
//===============================================================================
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tiff") suffix


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
	//open the file
	print("Processing: " + input + File.separator + file);
	open(input + File.separator + file);		
	selectWindow(file);
	
	
	//make a binary mask
	setAutoThreshold("Otsu");
	//run("Threshold...");
	//setThreshold(0, 1);
	run("Convert to Mask");
	
	
	//Smooth out the mask a bit, first remove some small bits and then dilate the connected shapes. 
	//This part depends a bit on the quality of the inital mask and might need to be adapted. 
	run("Erode");
	run("Erode");
	run("Erode");
	run("Erode");
	run("Erode");
	run("Dilate");
	run("Dilate");
	run("Close-");
	run("Dilate");
	run("Erode");
	run("Close-");
	run("Dilate");
	run("Close-");
	run("Dilate");
	run("Close-");
	
	//divide by 255 so that the values are 0 and 1 
	run("Divide...", "value=255.000");
	setMinAndMax(0, 1);
	
	// save file to output folder 
	print("Saving to: " + output);
	saveAs("Tiff", output + File.separator +  file);
	selectWindow(file);
	close(file);
}
print("Done");