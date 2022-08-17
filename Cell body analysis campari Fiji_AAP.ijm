
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness area_fraction display redirect=None decimal=3");

  title = "Intensity Sholl";
  types = newArray("1-auto-detecting cell body", "2-cell body verification", "3-ROI intensity extraction");
  Dialog.create("Example Dialog");
  Dialog.addChoice("Type:", types);

  Dialog.show();

  type = Dialog.getChoice();

print(type);

 if(type=="1-auto-detecting cell body")
  {
  	print("yes");
  	  Dialog.create("Instructions for auto-detecting cell body");
  Dialog.addMessage("Select a folder that contains '.czi' files. \n'.czi' files need to be z-stacks for CaMPARI images. \n NOTE: The files need to be located in a file path that has no spaces (See readme file for more details).", 14);
  Dialog.show;

  Dialog.create("Note: If cell body detection is failing.");
  Dialog.addMessage("This macro is desgined to detect cell bodies based on Fgreen intensity. This macro assumes the Fgreen stack is the second channel. ", 14);
  Dialog.show;

dir=getDirectory("Choose folder of all uncompressed videos"); 
  list = getFileList(dir);
hh=list.length+1;
print(hh);
  for(e=0; e<list.length; e++){
 if (endsWith(list[e], ".czi")){
  	close ("ROI Manager");
  	pse= replace( list[e] , " |.czi" , "");
  	psee= replace( list[e] , " |.czi" , "");
  	dss=dir+pse;
  	dsers=dss+".czi";
  	print(dsers);
File.rename(dir+list[e], dsers);

  run("Bio-Formats Importer", "open=" + dsers + " color_mode=Default view=Hyperstack stack_order=XYCZT");

selectWindow(pse+".czi");
run("Z Project...", "projection=[Max Intensity]");
saveAs("Tiff", dss+".tiff");




names=getTitle;


names1 = replace( names , ".czi" , "_" ); 
 rename("used"); 
run("Duplicate...", "duplicate");
run("8-bit");
setSlice(1);
run("Delete Slice", "delete=channel");
setAutoThreshold("Moments no-reset");
//run("Threshold...");
run("Convert to Mask");
run("Invert");

run("Erode");
run("Erode");



run("Dilate");
run("Dilate");
run("Dilate");

run("Remove Outliers...", "radius=1 threshold=50 which=Bright");
run("8-bit");


run("Analyze Particles...", "size=20-200 circularity=0.08-1.00 display exclude clear include add");

close("used");
close("used-1");
close(pse+".czi");

roiManager("Save", dss+"_roi.zip");


close ("ROI Manager");

close ("Results");

}
  }



close("Log");
close("Results");

  }


  if(type=="2-cell body verification")
  {
  	print("no");
  	  Dialog.create("Instructions for cell body verification");
  Dialog.addMessage("This macro is used for verifying ROIs around cell bodies of interest. \n Select the same folder as the First step. \n", 14);
  Dialog.show;


  dire=getDirectory("Choose folder of all uncompressed videos"); 
  list = getFileList(dire);


  for(e=1; e<list.length; e++){
 if (endsWith(list[e], ".tiff")){
 	roiManager("Show None");
close ("ROI Manager");
        print(list[e]);       
open(dire+list[e]);
ro=replace(list[e],".tiff","_roi.zip");
open(dire+ro);
setSlice(1);
run("Enhance Contrast", "saturated=0.35");



roiManager("Show All with labels");

  title = "Draw rest of ROI and click OK";
  msg = "If necessary, delete incorrect ROIs from the ROI manager. \nUsing any freehand selection draw new ROIs as necessary, then click \"OK\".";
  waitForUser(title, msg);
roiManager("Save", dire+ro);
  
roiManager("Show None");
close ("ROI Manager");
  close ();	
  }
  
  close("Log");
  }



  }

  if(type=="3-ROI intensity extraction")
  {
  	print("no");
  	  Dialog.create("Instructions for ROI area normalized intensity");
  Dialog.addMessage("This macro is used for quantifying area normalized intensities of ROIs. \n Select the same folder as the First and Second step. \nData are stored in the same location as input folder. \nData format: File name(suffix denotes ROI number)___slice number___intensity", 14);
  Dialog.show;





close("Log");
dire=getDirectory("Choose folder of all uncompressed videos"); 
  list = getFileList(dire);

  

  for(e=1; e<list.length; e++){
 if (endsWith(list[e], ".tiff")){
 	roiManager("Show None");
close ("ROI Manager");
             
open(dire+list[e]);
ro=replace(list[e],".tiff","_roi.zip");
open(dire+ro);
   

for (xx=0; xx<roiManager("count"); xx++) {
	//print(xx);
//roiManager("Delete");
selectWindow(list[e]);

roiManager("Select", xx);
run("Plot Z-axis Profile");
fev=list[e]+xx;
 Plot.getValues(x, y);
  for (er=0; er<x.length; er++)
      print(fev,x[er], y[er]);
      close();
}



close ("ROI Manager");
selectWindow(list[e]);
close();


      
  }
  }
selectWindow("Log");
saveAs("Text", dire+"/CaMPARI_soma_intensity.csv");

  }