//===============================================================================
// Opens raw image stacks from Imaris software, spilts the channels, renames the channels and saves separate tiffs
// - Laura Breimann - 
//===============================================================================


// Define input and output folders as well as image type
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".ims") suffix


// this prevents the opening of the images, comment this out if you want to see the images while it's processing 
setBatchMode(true);


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
	
	// open file and get title
	// only uses the first and highest resolution image in the imaris file
	print("Processing: " + input + File.separator + file + " " + "Resolution Level 1");
	location = input + File.separator + file;
	run("Bio-Formats Importer", "open=[location] color_mode=Default view=Hyperstack stack_order=XYCZT series_1 input=input output=output suffix=.ims");
	title = getTitle();
	
	//split channels 
	run("Split Channels");
	
	// the follwing code exprects a 4 channel image stack with the order of DAPI, GFP, smFISH-1, smFISH-2
	// adapt the follwing code if the order is different in the images
	
	//select and save DAPI channel
	selectWindow("C1-" + title);
	resetMinAndMax();
	run("Grays");
	saveAs(".tif", output + File.separator + file + "_DAPI" + ".tif");
	close();
	
	
	//select and save GFP channel
	selectWindow("C2-" + title);
	rename(title + "_C2");
	run("Duplicate...", "duplicate");
	selectWindow(title + "_C2");
	resetMinAndMax();
	run("Grays");
	saveAs(".tif", output + File.separator + file + "_GFP" + ".tif");
	close();
	
	
	//make max projection of GFP channel
	selectWindow(title + "_C2" + "-1");
	run("Z Project...", "projection=[Max Intensity]");
	resetMinAndMax();
	run("Grays");
	saveAs(".tif", output + File.separator + file + "_GFP_max" + ".tif");
	close();
	
			
	//select and save smFISH-1 channel
	selectWindow("C3-" + title);
	run("Grays");
	resetMinAndMax();
	saveAs(".tif", output + File.separator + file + "_C3" + ".tif");
	close();
	
	//select and save smFISH-2 channel
	//selectWindow("C4-" + title);
	//run("Grays");
	//resetMinAndMax();
	//saveAs(".tif", output + File.separator + file + "_C4" + ".tif");
	//close();
	
		
	//saved all images info
	print("Saved to: " + output);
		
	
	close();
		
	
}

// close all windows
print("Done");
run("Close All");

