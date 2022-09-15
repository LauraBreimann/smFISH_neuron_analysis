/*
 * Macro template to process multiple open images
 */

#@ File(label = "Output directory", style = "directory") output
#@ String(label = "Soma mask label") pattern
#@ String(label = "DAPI mask label") pattern2

//processOpenImages();

/*
 * Processes all open images. If an image matches the provided title
 * pattern, processImage() is executed.
 */
 //function processOpenImages() {
//	n = nImages;
//	setBatchMode(true);
//	for (i=1; i<=n; i++) {
//		selectImage(i);
//		imageTitle = getTitle();
//		imageId = getImageID();
//		if (matches(imageTitle, "(.*)"+pattern+"(.*)"))
//			processImage(imageTitle, imageId, output);
	
//	}
//	}
//	setBatchMode(false);
//}


 setBatchMode(true);
 imgArray = newArray(nImages);
 //soma_image =[];
 //dapi_image = [] ; 
 for (i=0; i<nImages; i++) {
 	selectImage(i+1);
 	imgArray[i] = getImageID(); 
 }
 //now we have a list of all open images, we can work on it:
 for (i=0; i< imgArray.length; i++) {
 	selectImage(imgArray[i]);
	imageTitle = getTitle();
 	if (matches(imageTitle, "(.*)"+pattern+"(.*)"))
 		soma_image = imageTitle;	
 	if (matches(imageTitle, "(.*)"+pattern2+"(.*)"))
 		dapi_image = imageTitle;
 	//processImage(soma_image, dapi_image, output);
 }

 //print("Processing: " + soma_image);
 //print("Processing: " + dapi_image);
 selectWindow(soma_image)
 selectWindow(dapi_image)
 imageCalculator("Subtract create", soma_image, dapi_image);
 
function processImage(soma_image, dapi_image, output) {
	
	imageCalculator("Subtract create", soma_image, dapi_image);
	
	print("Processing: " + imageTitle);
		pathToOutputFile = output + File.separator + imageTitle + "mini_soma.tif";
	print("Saving to: " + pathToOutputFile);
}
