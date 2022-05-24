<div align="center">
  
# Documentation for smFISH analysis in neurons

</div>


### Pipeline

* _**1.	Tiff file extraction from imaris files**_
* _**2.	Mask creation using Ilastik**_
* _**3.	Mask refinement and area detection using Fiji**_
* _**4.	smFISH analysis using RS-FISH**_
* _**5.	Mask filtering using RS-FISH**_
* _**6.	Colletion of all datasets and plotting**_



<br />

<div style="text-align: justify">
  
 ### 1.	Tiff file extraction from imaris files
  
Use ```open_ims_split_gfp_max.ijm``` script to open a set of .ims files, split the channels and resave them as single tiff files. 
  
  
 ### 2.	Mask creation using Ilastik
  
  Use Ilastik (cite) to create masks. 
  The Autocontex analysis step
  Select Simple segmentation as output files format
  Select tiff file to export. 
  Batch mode for images that looks similar
  
  
 ### 3.	Mask refinement and area detection using Fiji
  
  Use the ```creating_mask.ijm``` to create binary masks from the segmentation. 
  Using the brush tool segemtnation can be corrected. 
  Also the seperation of soma and neurite  can be done with the brush and image calculation tool. 
  
  
  
 ### 4.	smFISH analysis using RS-FISH
  
 Optional to prepare the images using a difference of Gaussian filer. The macro script ```DoG_filter.ijm``` can be used. The sigma for the gaussian blur needs to be adapted for a new set of images. 
  
 To detect smFISH spots in the image, the Fiji plugin [RS-FISH](https://github.com/PreibischLab/RS-FISH) can be used (info on how to use RS-FISH and how to download the plugin can be found on the [RS-FISH](https://github.com/PreibischLab/RS-FISH) GitHub page). The macro ```RS-FISH_macro.ijm``` can be used to run RS-FISH in batch mode. Determine the parameters before using one representative image and then run the rest of the images in batch mode. 
  
  
 ### 5.	Mask filtering using RS-FISH
  
  With the created mask, the resulting csv files can be filtered using the [RS-FISH](https://github.com/PreibischLab/RS-FISH) plugin "Mask filtering". Go to ```Plugins > RS-FISH > Tools > Mask``` filtering. 
  
 
  <img src="https://github.com/LauraBreimann/smFISH_neuron_analysis/blob/main/screenshots/mask_filtering_plugin.png" alt="Screenshot oof the mask filtering plugin" width="800">
  
  
  
 ### 6.	Colletion of all datasets and plotting
  
  To detect the size of the created masks run ```record_size_of_mask.ijm``` . Make sure that files are binary files with values of 0 and 1 and that all have the same scale set. 
  
  To create a dataset for plotting, this python script searches all the files and combines them, but this might be dependen on the file structure. 
  
  ```Collect_counts_and_mask_sizes.ipynb```
  
  To plot from the created database: ```Plot_smFISH_values.ipynb```
