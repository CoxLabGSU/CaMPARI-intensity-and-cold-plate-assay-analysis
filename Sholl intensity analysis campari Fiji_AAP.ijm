
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness area_fraction display redirect=None decimal=3");

  title = "Intensity Sholl";
  types = newArray("1-Batch max intensity projection", "2-background clearing and cell body identification", "3-Automatic Sholl ROIs and data extraction");
  Dialog.create("CaMPARI Intensity Sholl Analysis");
  Dialog.addChoice("Type:", types);

  Dialog.show();

  type = Dialog.getChoice();

print(type);

 if(type=="1-Batch max intensity projection")
  {
  	print("yes");
  	  Dialog.create("Instructions for auto-detecting cell body");
  Dialog.addMessage("Select a folder that contains '.czi' files. \n'.czi' files need to be z-stacks for CaMPARI images. \n NOTE: The files need to be located in a file path that has no spaces (See readme file for more details).", 14);
  Dialog.show;




  
   requires("1.33s"); 
   dir = getDirectory("Choose a Directory ");
   setBatchMode(true);
   count = 0;
   countFiles(dir);
   n = 0;
   processFiles(dir);
   //print(count+" files processed");
   
   function countFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              countFiles(""+dir+list[i]);
          else
              count++;
      }
  }

   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              processFiles(""+dir+list[i]);
          else {
             showProgress(n++, count);
             path = dir+list[i];
             processFile(path);
          }
      }
  }



  function processFile(path) {
  	close ("ROI Manager");
  	pse= replace( list[i] , " |.czi" , "");
  	psee= replace( list[i] , " |.czi" , "");
  	dss=dir+pse;
  	dsers=dss+".czi";
  	print(dsers);
File.rename(path, dsers) ;

  run("Bio-Formats Importer", "open=" + dsers + " color_mode=Default view=Hyperstack stack_order=XYCZT");

run("Z Project...", "projection=[Max Intensity]");
saveAs("Tiff", dss+".tiff");

}

}

  


  if(type=="2-background clearing and cell body identification")
  {
  	print("no");
  	  Dialog.create("Instructions for background clearing and cell body identification");
  Dialog.addMessage("This macro is used for removing unwanted background, isolating the neuron of interest, and marking the center of the cell body. \n Select the same input folder as the First step. \n", 14);
  Dialog.show;
  
  Dialog.create("Note: If cell body detection is not failing.");
  Dialog.addMessage("This macro is desgined to detect cell bodies based on Fgreen intensity. This macro assumes the Fgreen stack is the second channel. ", 14);
  Dialog.show;

mire=getDirectory("Select your input folder");
dire=getDirectory("Select your output folder - Can not be same as input folder"); 
  list = getFileList(mire);

run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness area_fraction display redirect=None decimal=3");

run("Wand Tool...", "tolerance=4 mode=Legacy smooth");
  for(e=0; e<list.length; e++){
 if (endsWith(list[e], ".tiff")){
 	roiManager("Show None");
close ("ROI Manager");
        print(list[e]);       
open(mire+list[e]);




run("Set Scale...", "distance=0 known=0 unit=pixel");
makeRectangle(1, 1, 1022, 1022);
run("Make Inverse");
setBackgroundColor(0, 0, 0);

run("Clear", "stack");
run("Select None");

setLocation(200, 1, 800, 800);
rename("me");
run("8-bit");
run("Duplicate...", "duplicate channels=2-2");
setLocation(200, 1, 800, 800);
rename("me-0003");
run("Threshold...");
setOption("BlackBackground", true);
//run("Convert to Mask");
run("Remove Outliers...", "radius=1 threshold=50 which=Bright");

setTool("Paintbrush Tool");
waitForUser("Brush out any unwanted branches,"+"\n"+"Then click ok.");
run("Convert to Mask");
run("Remove Outliers...", "radius=1 threshold=50 which=Bright");
setLocation(200, 1, 800, 800);

setTool("Wand Tool");
waitForUser("Shift + Click on all branches,"+"\n"+"Then click ok.");
roiManager("Add");
setLocation(200, 1, 800, 800);

run("Make Inverse");
roiManager("Add");
selectWindow("me");
setLocation(200, 1, 800, 800);

run("Stack to Images");
selectWindow("me-0001");
selectWindow("me-0002");
selectWindow("me-0003");
run("Images to Stack");
Stack.swap(1, 3);
Stack.swap(1, 2);



roiManager("Select", 1);
run("Clear", "stack");

run("Select None");

run("Canvas Size...", "width=2048 height=2048 position=Center zero");
ro=replace(list[e],".tiff","_roi.zip");
//saveAs("Tiff", dire+replace(list[e],".tiff","_clean.tiff"));


close ("ROI Manager");
setTool("Point");
setSlice(3);
setLocation(200, 1, 800, 800);
waitForUser("Click on the center of the cell body,"+"\n"+"Then click ok.");
saveAs("Tiff", dire+replace(list[e],".tiff","_clean.tiff"));

roiManager("Add");

roiManager("Save", dire+ro);

File.delete(mire+list[e]);
 
close("me-1");
close("me");

roiManager("Show None");
close ("ROI Manager");
close("Results");
  close ();	
  print(list.length-e);
  }}





  }
if(type=="3-Automatic Sholl ROIs and data extraction")
  {
  	print("no");
  	  Dialog.create("Instructions for Sholl ROIs and data extraction");
  Dialog.addMessage("This macro is used draw circular ROIs and CaMPARI intensity data extraction. \n Select the same folder as the output folder from step 2. \nNOTE: This macro continually has image pop-ups rendering the computer unsuable while the macro is in progress.", 14);
  Dialog.show;


dire=getDirectory("Choose folder with clean neurons"); 
  list = getFileList(dire);


  for(e=0; e<list.length; e++){
 if (endsWith(list[e], "clean.tiff")){
 	close("roi manager");
 	roiManager("Show None");

        print(list[e]);       
open(dire+list[e]);



//run("Brightness/Contrast...");

ro=replace(list[e],"_clean.tiff","_roi.zip");
open(dire+ro);
rename("me");

roiManager("Select", 0);
Roi.getCoordinates(x,y);
xme=x[0];
yme=y[0];
roiManager("Select", 0);
roiManager("Delete");
makeRectangle(0, yme, 2048, 1);
run("Invert", "stack");
run("Select None");
cell=1;
max_radi=1124;
pix_step=10;

for (i = cell; i < max_radi; i++) {
	selectWindow("me");
		run("Duplicate...", "duplicate range=3-3");
		
makeOval(xme-i/2, yme-i/2, i, i);
run("Clear");
nex_step=(i/2)+pix_step/2;
makeOval(xme-nex_step, yme-nex_step, i+pix_step, i+pix_step);
run("Make Inverse");
run("Clear");
run("Convert to Mask");
run("Create Selection");
roiManager("add");

close();
}


nrois=roiManager("count");
print(nrois);
//run("Images to Stack");
roiManager("Save", dire+ro);
  
//makeRectangle(512, 512, 1024, 1024);
//run("Crop");
close("roi manager");
close("me");
 }}


  for(e=0; e<list.length; e++){
 if (endsWith(list[e], "clean.tiff")){


 	close("roi manager");
 	roiManager("Show None");

        print(list[e]);       
open(dire+list[e]);
ro=replace(list[e],"_clean.tiff","_roi.zip");
open(dire+ro);
rename("me");


print("Distance_in_pixel", "area","red_mean/green_mean","green_mean","red_mean","green_raw","red_raw");

nrois=roiManager("count");
    
 Table.create("Results-1");



 
 for (xx=0; xx<nrois; xx++) {
        data = xx;
        Table.set("distance in pixels", xx, data);
     }
	
for (i = 0; i < nrois; i++) {


	roiManager("Select", i);
	setSlice(2);
	run("Measure");
	areA=getResult("Area", 0);

	green_mean=getResult("Mean", 0);
	green_raw=getResult("RawIntDen", 0);
	close("Results");
setSlice(1);
	run("Measure");
	red_mean=getResult("Mean", 0);
	red_raw=getResult("RawIntDen", 0);
	close("Results");
	print((i+1),areA,(red_mean/green_mean),green_mean,red_mean,green_raw,red_raw);

Table.set("area", (i+1), areA);
Table.set("red_mean/green_mean", (i+1), (red_mean/green_mean));
Table.set("green_mean", (i+1), green_mean);
Table.set("red_mean", (i+1), red_mean);
Table.set("green_raw", (i+1), green_raw);
Table.set("red_raw", (i+1), red_raw);
}
    
    
    ro_log=replace(list[e],"_clean.tiff","_data.txt");

    Table.rename("Results-1", "Results");
	saveAs("Results", dire+ ro_log);

close("Results");
close("roi manager");
close("me");
 }
 
 }

  }

 