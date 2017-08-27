void keyPressed() {
  if (key==' '||keyCode==33) { //REC works with space or pgdn from clicker
    doButtonRec();
  }

  if(key=='c'||key=='C'||keyCode==34){  //CAM works with C key or pgup from clicker
    doButtonCam();
  }
  
  if (key=='f' || key=='F') openAppFolderHandler();
}

void mouseReleased(){
  if (buttons[buttonRecNum].clicked) { //REC
    doButtonRec();
  }
  
  else if (buttons[buttonOscNum].clicked) {  //OSC from OSCeleton
    doButtonOsc();
  }
  
  else if (buttons[buttonSaveNum].clicked) { //SAVE
    doButtonSave();
  }
  else if (buttons[buttonPlayNum].clicked) { //PLAY
    doButtonPlay();
  }
  else if (buttons[buttonStopNum].clicked) {  //STOP
    doButtonStop();
  }
  else if (buttons[buttonCamNum].clicked) {  //CAM
    doButtonCam();
  }
  else if (buttons[buttonBvhNum].clicked) {  //formerly BVH, now OPEN FOLDER
    //doButtonBvh();
    buttonFreeze = true;
    buttons[buttonBvhNum].clicked = false;
    buttons[buttonBvhNum].hovered = false;
    openAppFolderHandler();
  }

if (buttons[buttonRecNum].hovered) {
    sayTextPrefix = "Record skeleton data";
}else if (buttons[buttonOscNum].hovered) {
    sayTextPrefix = "Record OSC data";
}else if (buttons[buttonSaveNum].hovered) {
    sayTextPrefix = "Save all XML files for After Effects";
}else if (buttons[buttonPlayNum].hovered) {
    sayTextPrefix = "Play back last saved XML file";
}else if (buttons[buttonStopNum].hovered) {
    sayTextPrefix = "Stop recording";
}else if (buttons[buttonCamNum].hovered) {
    sayTextPrefix = "Toggle camera view";
}else if (buttons[buttonBvhNum].hovered) {
    //sayTextPrefix = "Import BVH file";
    sayTextPrefix = "Open app folder";
}
}

void buttonHandler() {
  //resets button freeze used when the open app folder button opens a new window
  if(mouseX != pmouseX || mouseY != pmouseY) buttonFreeze = false;
  for (int i=0;i<buttons.length;i++) {
  if(modePreview){
    buttons[buttonCamNum].checkButton();
    buttons[buttonCamNum].drawButton();
  }else{
    buttons[i].checkButton();
    buttons[i].drawButton();
  }
  }
}

void buttonsRefresh() {
  for (int i=0;i<buttons.length;i++) {
    buttons[i].clicked = false;
  }
}

void modesRefresh() {
  if(dialogueFile!="none") countdown.dialogue.close();
  countdown = new Countdown(8, 2);
  buttonsRefresh();
  counter=0;
  modeRec = false;
  modeOsc = false;
  modePlay = false;
  modeExport = false; 
  modeBvh = false;
  modeStop=false;
  modePreview=false;
  bvhConversionCounter = 0;
}

void doButtonRec(){
     //toggle
    if(!modeRec){
    if (firstRun) {
      firstRun=false;
      if(!loadSimpleOpenNIatStart) setupUser(); //this sets up SimpleOpenNi
    }
    doButtonStop();
    xmlRecorderInit();
    modeRec = true;
    if (!needsSaving) {
      needsSaving = true;
      masterFileCounter++;
    }
  }else{
    doButtonStop();
  }
}


void doButtonOsc(){ //toggle
  if(!modeOsc){
    doButtonStop();
    xmlRecorderInit();
    modeOsc = true;
    if (!needsSaving) {
      needsSaving = true;
      masterFileCounter++;
    }
  }else{
    doButtonStop();
  }
}

void doButtonStop(){ //one-off
    modesRefresh();
    if (needsSaving) {
      countdown.countdownBeep.play();
      xmlSaveToDisk();
    }
    needsSaving=false;
}

void doButtonPlay(){ //one-off
     doButtonStop();
    if(dialogueFile!="none") countdown.dialogue.play();
    modePlay = true;
    xmlPlayerInit(masterFileCounter);
}

void doButtonSave(){ //one-off
    doButtonStop();
    modeExport = true;
    if(savePins) aePinSaveToDisk(masterFileCounter);    
    if(savePoints) aePointSaveToDisk(masterFileCounter);    
    if(savePoints3D) aePoint3DsaveToDisk(masterFileCounter);    
    if(saveJson) jsonSaveToDisk(masterFileCounter);    
    if(saveJsx) aeJsxSaveToDisk(masterFileCounter);    
    if(saveMaya) mayaSaveToDisk(masterFileCounter);
    if(saveObj) objSaveToDisk(masterFileCounter);
}

void doButtonCam(){ //toggle
    if (modePreview) {
      doButtonStop();
    }
    else if (!modePreview) {
      if (firstRun) {
        firstRun=false;
        if(!loadSimpleOpenNIatStart) setupUser(); //this sets up SimpleOpenNi
      }
      doButtonStop();
      modePreview=true;
    }
}

void doButtonBvh(){
  doButtonStop();
  try{
    chooseFolderDialog();
    delay(saveDelayInterval);
    modeBvh = true;
    bvhConversionCounterMax = bvhNames.size();
    bvhBegin();
  }catch(Exception e){
    doButtonStop();
  }
}

//~~~~~~~~~~~ broken ~~~~~~~~~~~~~~~~~~~~~~
void chooseFolderDialog(){
  selectFolder("Select a folder to process:", "folderSelected");
}

void folderSelection(File folderPath){
    if (folderPath == null) {
      // If a folder was not selected
      println("No folder was selected...");
    } else {
      println(folderPath);
      countFrames(""+folderPath);
    }
}

void countFrames(String usePath) {
    bvhNames = new ArrayList();
    //loads a sequence of frames from a folder
    File dataFolder = new File(usePath); 
    String[] allFiles = dataFolder.list();
    for (int j=0;j<allFiles.length;j++) {
      if (allFiles[j].toLowerCase().endsWith("bvh")) {
        bvhNames.add(usePath+"/"+allFiles[j]);
      }
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void openAppFolderHandler(){
  if(System.getProperty("os.name").equals("Mac OS X")){
    try{
      print("Trying OS X Finder method.");
      //open(sketchPath("data"));
      Desktop.getDesktop().open(new File(sketchPath("") + "/data"));
    }catch(Exception e){ }
  }else{
    try{
      print("Trying Windows Explorer method.");
      Desktop.getDesktop().open(new File(sketchPath("") + "/data"));
    }catch(Exception e){ }
  }
}