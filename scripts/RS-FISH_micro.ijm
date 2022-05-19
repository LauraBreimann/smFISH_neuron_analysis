// This macro script runs the radial symmetry (RS) FIJI plug-in on all the images in all the sub-directories of the defined dir
// After finding the best parameters using the RS plugin GUI interactive mode on one example image,
// You can run this macro script on the entire dataset.
// Just change the directory path, and the values of the parameters in the begining of the script

// You can run this script either in the ImageJ GUI or headless (also from cluster) using this command (linux):
// fiji_dir_path/ImageJ-linux64 --headless --run /path/to/this/script/RS_macro.ijm &> /path/to/where/you/want/yourlogfile.log

// The detection result table will be saved to the same directory as each image it was calculated for.

// Path the tif files to be processed, searches all sub-directories.
dir = "/Users/laurabreimann/Desktop/images_smFISH-2_blur-5/"
// Location of file where all run times will be saved:
//timeFile = "/Users/laurabreimann/Desktop/RS_Exe_times.txt";


//////// Define RS parameters: //////////

anisotropy = 1.00; 		// anisotropy
sigmaDoG = 1.6115; 			// sigma
thresholdDoG = 0.0001; 			// threshold
supportRadius = 2; 		// support
inlierRatio = 0.219			// min_inlier_ratio
maxError = 0.50340486; // max_error
intensityThreshold=0;  		// spot_intensity_threshold
imMin=0;   //min Image intentisy
imMax=10000;  //max Image intensity



setBatchMode(true);

///////////////////////////////////////////////////


walkFiles(dir);

// Find all files in subdirs:
function walkFiles(dir) {
	list = getFileList(dir);
	for (i=0; i<list.length; i++) {
		if (endsWith(list[i], "/"))
		   walkFiles(""+dir+list[i]);

		// If image file
		else  if (endsWith(list[i], ".tif")) 
		   processImage(dir, list[i]);
	}
}


function processImage(dirPath, imName) {
	
	open("" + dirPath + imName);

	results_csv_path = "" + dirPath + imName + " sigma=" + sigmaDoG + 
	" threshold=" + thresholdDoG + 
	" supportRadius=" + supportRadius + 
	" min_inlier_ratio=" + inlierRatio +  
	" max_error=" + maxError + ".csv";
	
	
	
	
	parameterString = "image=" + imName + 
	" mode=Advanced" +
	" anisotropy=" + anisotropy + 
	" robust_fitting=RANSAC" + 
	" use_anisotropy" +
	" image_min=" + imMin + 
	" image_max=" + imMax + 
	" sigma=" + sigmaDoG + 
	" threshold=" + thresholdDoG + 
	" support=" + supportRadius + 
	" min_inlier_ratio=" + inlierRatio + 
	" max_error=" + maxError + 
	" background=[No background subtraction]" +
	" spot_intensity_threshold=" + intensityThreshold + 
	" results_file=[" + results_csv_path + "]";
	

	

	print(parameterString);

	startTime = getTime();
	run("RS-FISH", parameterString);
	//exeTime = getTime() - startTime; //in miliseconds
	
	// Save exeTime to file:
	//File.append(results_csv_path + "," + exeTime + "\n ", timeFile);

	// Close all windows:
	run("Close All");	
	while (nImages>0) { 
		selectImage(nImages); 
		close(); 
    } 
} 
