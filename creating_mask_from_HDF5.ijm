
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
	print("Processing: " + input + File.separator + file);
			
	run("HDF5...", "open=[/Volumes/mix_files/neuron_smFISH/Ago2_GFPReporter/mask/max/20220419_Ago2GFP_01_2022-04-19_Sam smifish CF25_13.58.13_1BGTHP2_FusionStitcher.h5]");
	
	run("8-bit");
	
	setAutoThreshold("Default");
	//run("Threshold...");
	run("Close");
	
	
	
	print("Saving to: " + output);
}
