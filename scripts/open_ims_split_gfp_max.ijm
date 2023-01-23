//===============================================================================
// Opens raw image stacks from Imaris software, spilts the channels, renames the channels and saves separate tiffs
// - Laura Breimann - 
//===============================================================================

extension = "lif";


dir = getDirectory("Select a directory containing one or several ."+extension+" files.");
output = getDirectory("Select a directory to save the output files");

files = getFileList(dir);


//setBatchMode(true);
k=0;
n=0;

run("Bio-Formats Macro Extensions");
for(f=0; f<files.length; f++) {
	if(endsWith(files[f], "."+extension)) {
		k++;
		id = dir+files[f];
		Ext.setId(id);
		Ext.getSeriesCount(seriesCount);
		print(seriesCount+" series in "+id);
		n+=seriesCount;
		for (i=0; i<seriesCount; i++) {
			run("Bio-Formats Importer", "open=["+id+"] color_mode=Default view=Hyperstack stack_order=XYCZT series_"+(i+1));
			fullName	= getTitle();
			dirName 	= substring(fullName, 0,lastIndexOf(fullName, "."+extension));
			fileName 	= substring(fullName, lastIndexOf(fullName, " - ")+3, lengthOf(fullName));

			getDimensions(x,y,c,z,t);
			
					
			//select window
			selectWindow(fullName);
	
			//split channels 
			run("Split Channels");
			
			// the follwing code exprects a 3 channel image stack with the order of DAPI, smFISH, GFP
			// adapt the follwing code if the order is different in the images
			
			//select and save DAPI channel
			selectWindow("C1-" + fullName);
			resetMinAndMax();
			run("Grays");
			saveAs(".tif", output + File.separator + fullName + "_DAPI" + ".tif");
			close();
			
			//select and save smFISH channel
			selectWindow("C2-" + fullName);
			run("Grays");
			resetMinAndMax();
			saveAs(".tif", output + File.separator + fullName + "_C2" + ".tif");
			close();
			
			
			//select and save GFP channel
			selectWindow("C3-" + fullName);
			rename(fullName + "_C3");
			run("Duplicate...", "duplicate");
			selectWindow(fullName + "_C3");
			resetMinAndMax();
			run("Grays");
			saveAs(".tif", output + File.separator + fullName + "_GFP" + ".tif");
			close();
			
			
			//make max projection of GFP channel
			selectWindow(fullName + "_C3" + "-1");
			run("Z Project...", "projection=[Max Intensity]");
			resetMinAndMax();
			run("Grays");
			saveAs(".tif", output + File.separator + fullName + "_GFP_max" + ".tif");
			close();
			
					
			
			
				
			//saved all images info
			print("Saved to: " + output);
				
			
			close();
				
	
}

// close all windows
print("Done");
run("Close All");

showMessage("Done with "+k+" files and "+n+" series!");
