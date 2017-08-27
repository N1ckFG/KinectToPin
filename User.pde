/* --------------------------------------------------------------------------
 * SimpleOpenNI User Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / zhdk / http://iad.zhdk.ch/
 * date:  02/16/2011 (m/d/y)
 * ----------------------------------------------------------------------------
 */

void setupUser(){
  if(multiThread){
  context = new SimpleOpenNI(this,SimpleOpenNI.RUN_MODE_MULTI_THREADED);
  }else{
  context = new SimpleOpenNI(this);
  }
  //context = new SimpleOpenNI(this);
  context.setMirror(mirror);  //mirrors view but not joint names; that must be done separately
   
  // enable depthMap generation 
  context.enableDepth();
  
  // enable skeleton generation for all joints
  //context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  context.enableUser();
 
  background(200,0,0);

  stroke(0,0,255);
  strokeWeight(3);
  //smooth();
  
  //size(context.depthWidth(), context.depthHeight()); 
}

void drawUser(){
  // update the cam
  context.update();
  
  // draw depthImageMap
  
  if(modePreview){
    if(camDelayCounter<camDelayCounterMax){
      camDelayCounter++;
    }else{
  
  
  if(previewLevel>1){
    previewInt = context.depthImage().pixels;
    for(int i=0;i<sW*sH;i+=previewLevel){
      previewImg.pixels[i] = previewInt[i];
      previewImg.updatePixels();
    }
    image(previewImg, 0,0);
   }else{
    image(context.depthImage(),0,0);
   }
    }
  }
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // draw the skeleton if it's available
  if(context.isTrackingSkeleton(1)){
    if(modePreview){
    drawSkeleton(1);
    if(sendOsc){
      simpleOpenNiEvent(1);
      oscSend(1);
    }
    }else if(modeRec){
    simpleOpenNiEvent(1);
    if(sendOsc) oscSend(1);
    }
  }
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId){
  // to get the 3d joint data
  /*
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
  println(jointPos);
  */
  
  stroke(0,0,255);
  strokeWeight(3);
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
 
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext,int userId){
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  context.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext,int userId){
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext,int userId){
  //println("onVisibleUser - userId: " + userId);
}
