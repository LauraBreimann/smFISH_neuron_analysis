/*
 * Macro template to process multiple open images
 */

#@ File(label = "Output directory", style = "directory") output
#@ String(label = "Title contains") pattern

processOpenImages();

/*
 * Processes all open images. If an image matches the provided title
 * pattern, processImage() is executed.
 */
function processOpenImages() {
	n = nImages;
	setBatchMode(true);
	for (i=1; i<=n; i++) {
		selectImage(i);
		imageTitle = getTitle();
		imageId = getImageID();
		if (matches(imageTitle, "(.*)"+pattern+"(.*)"))
			processImage(imageTitle, imageId, output);
	}
	setBatchMode(false);
}

/*
 * Processes the currently active image. Use imageId parameter
 * to re-select the input image during processing.
 */
function processImage(imageTitle, imageId, output) {

	selectWindow(imageTitle);
	run("To ROI Manager");
	roiManager("Show All without labels");
	RoiManager.setGroup(0);
	RoiManager.setPosition(0);
	roiManager("Set Color", "white");
	roiManager("Set Line Width", 0);
	roiManager("Save", output + File.separator + imageTitle + ".zip");
	close();
	roiManager("Deselect");
	roiManager("Delete");
	run("Close All");

	print("Processing: " + imageTitle);
	//pathToOutputFile = output + File.separator + imageTitle + ".png";
	//print("Saving to: " + pathToOutputFile);
}
