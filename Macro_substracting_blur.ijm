// Ask for the input and output folders
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
	//open file
	open(input + File.separator + file);
	print("Processing: " + input + File.separator + file);
	print(input);
	print(file);
	print(output);
	selectWindow(file);
	//duplicate file and rename
	run("Duplicate...", "title=blur duplicate");
	// add gaussian blur to duplicated image
	run("Gaussian Blur...", "sigma=5 stack");
	// substract duplicated image from original
	imageCalculator("Subtract create stack", file,"blur");
	selectWindow("blur");
	close("blur");
	selectWindow(file);
	close(file);
	// save new image to folder
	print("Saving to: " + output);
	saveAs("Tiff", output + File.separator +  file);
	selectWindow(file);
	close(file);


	
}