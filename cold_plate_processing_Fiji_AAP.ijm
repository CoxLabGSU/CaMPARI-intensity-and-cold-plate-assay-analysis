imagesize=250; 
list = getList("image.titles");

run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness area_fraction display redirect=None decimal=3");
num_video=list.length;

dire=getDirectory("Choose folder of all uncompressed videos"); 
   File.makeDirectory(dire+"600_frames_and_fin_videos"); 
   File.makeDirectory(dire+"temp_raw"); 
   dir=dire+"/600_frames_and_fin_videos/";
   outdir=dire+"/temp_raw/";
for (xx=0; xx<num_video; xx++) 
{
	zzx = getSliceNumber();
zzy= zzx+600;
names=getTitle;

names1 = replace( names , ".avi" , "_" ); 
run("Slice Keeper", "first=zzx last=zzy increment=1");
//run("AVI... ", "compression=JPEG frame=30 save");
//names=getTitle;
ymee= names1 + zzx;
//+ random

print(ymee);




gname=getTitle;


close ("ROI Manager");
//run("Crop");
run("Clear Results");


saveAs("Avi", dir + ymee);
close();
close();
print("This ones are left to do:");
wliest=getList("image.titles");
print(wliest.length);
}
   requires("1.33s"); 

   run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction display redirect=None decimal=3");
   setBatchMode(true);

    //s = getString("Enter a Threshold:", s);
   //print(s);
     
   
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
   

  function processFile(path) {
      run("Collect Garbage");
           open(path);
          
//add your favorite code below dum dum!!
    makeRectangle(1, 1, 1919, 1079);
run("Crop");

names=getTitle;


names1 = replace( names , ".avi" , "_" ); 
 rename("used"); 

			
run("Slice Keeper", "first=1 last=1 increment=1");

run("8-bit");
setAutoThreshold("Triangle dark");
//setThreshold(s, 255);//Change this threshold based on your imaging conditions
setOption("BlackBackground", false);
run("Convert to Mask", "method=Default background=Dark");




run("Remove Outliers...", "radius=6 threshold=50 which=Dark stack");


run("Analyze Particles...", "size=800-5500 circularity=0.2-1.00 display clear ");

num_larvae=nResults;
print(num_larvae);
for (xx=0; xx<num_larvae; xx++) {
	selectWindow("used");
Mex=getResult("XM",xx);
Mey=getResult("YM",xx);

print(path);

makeRectangle(Mex-(imagesize/2), Mey-(imagesize/2), imagesize, imagesize);

roiManager("Add");


    roiManager("select",0);

 run("Duplicate...", "duplicate");
 
 xxx=num_larvae-xx;
 print(xxx);
ymee= names1 + xxx;
dem1 = replace( ymee , "[)]" , "" ); 
dem2 = replace( dem1 , "[(]" , "" ); 
dem3 = replace( dem2 , " " , "_" ); 
//run("Canvas Size...", "width=imagesize height=imagesize position=Center zero");
saveAs("Avi", outdir + dem3+"_"+imagesize);
close();
roiManager("Delete");
 



}

close();

close ("ROI Manager");


  }
  print("Done Cropping all folders");
   }



   
list = getFileList( outdir );



run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness area_fraction display redirect=None decimal=3");

File.makeDirectory(dir+"trouble");
troubdir=dir+"trouble/";

for ( xx=0; xx<list.length; xx++ )


{
	open( outdir + list[xx] );
	print(list.length-xx);
	names=getTitle;
	selectWindow(names);
run("Duplicate...", "duplicate");
run("Duplicate...", "duplicate");
selectWindow(names);
close();
run("8-bit");
//setAutoThreshold("Triangle dark");
run("Convert to Mask", "method=Triangle background=Dark calculate");
run("Analyze Particles...", "size=800-Infinity display clear add stack");
close();
print(nResults);



if (nResults==nSlices){
	for ( t=0; t<nSlices; t++ ){
			roiManager("Select", t);
			run("Enlarge...", "enlarge=12");
			run("Make Inverse");
			setBackgroundColor(0, 0, 0);
			run("Clear", "slice");
			}
			
			ymee= names ;
			print(ymee);
			run("Canvas Size...", "width=imagesize height=imagesize position=Center zero");
			saveAs("Avi", dir + ymee);
			close();
			close ("ROI Manager");}
	else{
		
			ymee=  names ;
			print(ymee);
			saveAs("Avi", troubdir + ymee);
			close();
			close ("ROI Manager");
	}

}







run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness area_fraction display redirect=None decimal=3");

troubdir=dir+"trouble/";
list = getFileList(  troubdir);
for ( xx=0; xx<list.length; xx++ )


{
	open( troubdir + list[xx] );
	//saveAs("Avi", troubdir +getTitle);
	print(list.length-xx);

names=getTitle;

run("Duplicate...", "duplicate");


run("Z Project...", "projection=[Max Intensity]");
run("8-bit");
setAutoThreshold("Li dark");
//run("Threshold...");
//setThreshold(117, 255);
setOption("BlackBackground", false);
run("Convert to Mask");
run("Analyze Particles...", "size=900-Infinity display exclude clear add");
close();
num_larva=nResults;

for ( w=0; w<num_larva; w++ ){

selectWindow(names);


run("Duplicate...", "duplicate");

roiManager("Select", w);
run("Enlarge...", "enlarge=14");
run("Make Inverse");
skslie=nSlices+1;
for ( xy=1; xy<skslie; xy++ )


{
	setSlice(xy);
run("Clear", "slice");

}


	ymee= replace(names,".avi","") ;
			print(ymee);		
run("Canvas Size...", "width=imagesize height=imagesize position=Center zero");
			saveAs("Avi", troubdir +ymee+"_"+w);
			close();	
			
}
close();
close();	
close ("ROI Manager");
}
print("All Done. Really. Finished.");imagesize=250; 
