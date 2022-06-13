//===============================================================================
// Creates a binary mask from of the soma portion that is not the nucleus
//  - Laura Breimann
//===============================================================================
#@ File (label = "DAPI directory", style = "directory") input
#@ String (label = "DAPI file suffix", value = ".tif") suffix
#@ File (label = "Output directory", style = "directory") output


//read in the DAPI file
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
	
	// create max-proejction
	run("Z Project...", "projection=Median");
	selectWindow(file);
	close(file);
	setMinAndMax(101, 125);
	saveAs("tiff", output + File.separator +  file + "_median");	

	
	
	
	//make a binary mask
	//run("Convert to Mask", "method=Otsu background=Dark calculate");
	//setThreshold(106, 255); //threshold found empirically
	//setAutoThreshold("Otsu dark");
	//run("Convert to Mask"); 
	setThreshold(101, 5000, "raw");
	//setThreshold(106, 255);
	run("Convert to Mask");
	
	//Smooth out the mask a bit, first remove some small bits and then dilate the connected shapes. 
	//This part depends a bit on the quality of the inital mask and might need to be adapted. 
	run("Erode");
	run("Erode");
	run("Close-");
	run("Fill Holes");
	run("Dilate");
	run("Close-");
	run("Fill Holes");
	run("Dilate");
	run("Close-");
	run("Fill Holes"); 
	
	//divide by 255 so that the values are 0 and 1 
	run("Divide...", "value=255.000");
	setMinAndMax(0, 1);
	
	// save file to output folder 
	print("Saving to: " + output);
	saveAs("tif", output + File.separator +  file + "_mask");
	saveAs("PNG", output + File.separator +  file + "_mask");	
	close();
}
print("Done");