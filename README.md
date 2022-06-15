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
  
Use the [Fiji](https://fiji.sc/) macro ```open_ims_split_gfp_max.ijm``` script to open a set of .ims (imaris software) files, split the channels and resave them as single tiff files. The script also renames the files, for this, the script exprects these channels in this order: 1. DAPI, 2. GFP, 3. smFISH-1, 4. smFISH-2. The script also saves a max projection of the GFP channel, which may be used to create a binary mask.
  
  
 ### 2.	Mask creation using Ilastik
  
[Ilastik](https://www.ilastik.org/) can be used to create a binary mask to filter the smFISH detections. Since neurons are pretty flat, mask are creeated from max projections of the GFP  channel. The ```Autocontex``` workflow uses pixel classification to segement the cell boundaries. For this cells are segemented in two rounds. After innitial training, similar images can be processed together in the batch mode. To export the masks, select the ```Simple segmentation``` output format and tiff as file format. 
    
  <img src="https://github.com/LauraBreimann/smFISH_neuron_analysis/blob/main/screenshots/GFP_max.jpg" alt="Max projection of the GFP channel" width="400">
  
   <img src="https://github.com/LauraBreimann/smFISH_neuron_analysis/blob/main/screenshots/mask_after_ilastik.png" alt="Binary mask after ilastik segmentation" width="400">
  
   
  
 ### 3.	Mask refinement and area detection using Fiji
  
Use the ```creating_mask.ijm``` to create binary masks from the Ilastik segmentation. Using the paintbrush tool, the segmentation can be corrected to remove small background signals or neighbouring cells by coloring them in white (with a value of 0). Small corrections on the masks can be perfromed using black (with a value of 1). Additionally, the separation of soma and neurite can be done with the brush and ```Image Calculator``` tool in Fiji. 
  
  <img src="https://github.com/LauraBreimann/smFISH_neuron_analysis/blob/main/screenshots/mask_total_neuron.png" alt="Binary mask of the full neuron" width="250">
  
  <img src="https://github.com/LauraBreimann/smFISH_neuron_analysis/blob/main/screenshots/mask_soma.png" alt="Binary mask of the soma" width="250">
  
  <img src="https://github.com/LauraBreimann/smFISH_neuron_analysis/blob/main/screenshots/mask_neurite.png" alt="Binary mask of the neurite" width="250">
  

  
 ### 4.	smFISH analysis using RS-FISH
  
 One optional step is to prepare the smFISH images using a difference of Gaussian filer using the macro script ```DoG_filter.ijm```. The sigma for the Gaussian blur needs to be adapted for each new set of images. 
  
 To detect smFISH spots in the image, the Fiji plugin [RS-FISH](https://github.com/PreibischLab/RS-FISH) can be used (info on how to use RS-FISH and how to download the plugin can be found on the [RS-FISH](https://github.com/PreibischLab/RS-FISH) GitHub page). The macro ```RS-FISH_macro.ijm``` can be used to run RS-FISH in batch mode. Determine the parameters before using one representative image and then run the rest of the images in batch mode. 
  
  
 ### 5.	Mask filtering using RS-FISH
  
  With the created mask, the resulting csv files can be filtered using the [RS-FISH](https://github.com/PreibischLab/RS-FISH) plugin "Mask filtering". Go to ```Plugins > RS-FISH > Tools > Mask filtering```. 
  
 
  <img src="https://github.com/LauraBreimann/smFISH_neuron_analysis/blob/main/screenshots/mask_filtering_plugin.png" alt="Screenshot of the mask filtering plugin" width="700">
  
  
  
 ### 6.	Colletion of all datasets and plotting
  
To detect the size of the created masks run the ```record_size_of_mask.ijm``` to create csv files for each binary mask containing an area measurement. Make sure that files are binary files with values of 0 and 1 and that all have set the same scale. 
  
  To create a dataset for plotting, this python script searches all the files and combines them, but this might be dependen on the file structure. 
  
  ```Collect_counts_and_mask_sizes.ipynb```
  
  To plot from the created database: ```Plot_smFISH_values.ipynb```
