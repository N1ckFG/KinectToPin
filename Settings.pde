class Settings {

  Data settings;

  Settings(String _s) {
    try {
      settings = new Data();
      settings.load(_s);
      for (int i=0;i<settings.data.length;i++) {
        if (settings.data[i].equals("Mirror Joints")) mirror = setBoolean(settings.data[i+1]);
        if (settings.data[i].equals("Send OSC Active")) sendOsc = setBoolean(settings.data[i+1]);
        if (settings.data[i].equals("OSC Send IP Number")) ipNumber = setString(settings.data[i+1]);
        if (settings.data[i].equals("OSC Send Port")) sendPort = setInt(settings.data[i+1]);
        if (settings.data[i].equals("OSC Receive Port")) receivePort = setInt(settings.data[i+1]);
        if (settings.data[i].equals("OSC Local Echo")) oscLocalEcho = setBoolean(settings.data[i+1]);
        if (settings.data[i].equals("OSC Channel Format (Isadora, OSCeleton, Animata)")) oscChannelFormat = setString(settings.data[i+1]);
        if (settings.data[i].equals("Export AE Puppet Pin Data (.txt)")) savePins = setBoolean(settings.data[i+1]);
        if (settings.data[i].equals("Export AE Point Control Data (.txt)")) savePoints = setBoolean(settings.data[i+1]);
        if (settings.data[i].equals("Export AE Point Control 3D Data (.txt)")) savePoints3D = setBoolean(settings.data[i+1]);
        if (settings.data[i].equals("Export JSON Data (.json)")) saveJson = setBoolean(settings.data[i+1]);
        if (settings.data[i].equals("Export AE Template Script (.jsx)")) saveJsx = setBoolean(settings.data[i+1]);
        if (settings.data[i].equals("Export Maya Script (.py)")) saveMaya = setBoolean(settings.data[i+1]);
        if (settings.data[i].equals("Export Pointcloud (.obj)")) saveObj = setBoolean(settings.data[i+1]);
        if (settings.data[i].equals("Original Capture Image Width")) sW = setInt(settings.data[i+1]);
        if (settings.data[i].equals("Original Capture Image Height")) sH = setInt(settings.data[i+1]);
        if (settings.data[i].equals("Original Capture Depth")) sD = setFloat(settings.data[i+1]);
        if (settings.data[i].equals("Destination AE Comp Width")) dW = setInt(settings.data[i+1]);
        if (settings.data[i].equals("Destination AE Comp Height")) dH = setInt(settings.data[i+1]);
        if (settings.data[i].equals("Framerate (max 30)")) fps = setInt(settings.data[i+1]);
        if (settings.data[i].equals("Camera Display Quality (1 = best)")) previewLevel = setInt(settings.data[i+1]);
        if (settings.data[i].equals("Enable Multithreading")) multiThread = setBoolean(settings.data[i+1]);
        if (settings.data[i].equals("Load SimpleOpenNI at Startup")) loadSimpleOpenNIatStart = setBoolean(settings.data[i+1]);
        if (settings.data[i].equals("SimpleOpenNI Autocalibration (no \"cactus pose\")")) autoCalibrate = setBoolean(settings.data[i+1]);
        if (settings.data[i].equals("Delay Between Saving Files")) saveDelayInterval = setInt(settings.data[i+1]);
        if (settings.data[i].equals("BVH Names List")) bvhJointNames = setStringArray(settings.data[i+1]);
        if (settings.data[i].equals("BVH Scale Factor")) bvhScaleFactor = setPVector(settings.data[i+1]);
        if (settings.data[i].equals("BVH Offset")) bvhOffset = setPVector(settings.data[i+1]);
       }
    } 
    catch(Exception e) {
      println("Couldn't load settings file. Using defaults.");
    }
  }

  int setInt(String _s) {
    return int(_s);
  }

  float setFloat(String _s) {
    return float(_s);
  }

  boolean setBoolean(String _s) {
    return boolean(_s);
  }
  
  String setString(String _s) {
    return ""+(_s);
  }
  
  String[] setStringArray(String _s) {
    int commaCounter=0;
    for(int j=0;j<_s.length();j++){
          if (_s.charAt(j)==char(',')){
            commaCounter++;
          }      
    }
    //println(commaCounter);
    String[] buildArray = new String[commaCounter+1];
    commaCounter=0;
    for(int k=0;k<buildArray.length;k++){
      buildArray[k] = "";
    }
    for (int i=0;i<_s.length();i++) {
        if (_s.charAt(i)!=char(' ') && _s.charAt(i)!=char('(') && _s.charAt(i)!=char(')') && _s.charAt(i)!=char('{') && _s.charAt(i)!=char('}') && _s.charAt(i)!=char('[') && _s.charAt(i)!=char(']')) {
          if (_s.charAt(i)==char(',')){
            commaCounter++;
          }else{
            buildArray[commaCounter] += _s.charAt(i);
         }
       }
     }
     println(buildArray);
     return buildArray;
  }

  color setColor(String _s) {
    color endColor = color(0);
    int commaCounter=0;
    String sr = "";
    String sg = "";
    String sb = "";
    String sa = "";
    int r = 0;
    int g = 0;
    int b = 0;
    int a = 0;

    for (int i=0;i<_s.length();i++) {
        if (_s.charAt(i)!=char(' ') && _s.charAt(i)!=char('(') && _s.charAt(i)!=char(')')) {
          if (_s.charAt(i)==char(',')){
            commaCounter++;
          }else{
          if (commaCounter==0) sr += _s.charAt(i);
          if (commaCounter==1) sg += _s.charAt(i);
          if (commaCounter==2) sb += _s.charAt(i); 
          if (commaCounter==3) sa += _s.charAt(i);
         }
       }
     }

    if (sr!="" && sg=="" && sb=="" && sa=="") {
      r = int(sr);
      endColor = color(r);
    }
    if (sr!="" && sg!="" && sb=="" && sa=="") {
      r = int(sr);
      g = int(sg);
      endColor = color(r, g);
    }
    if (sr!="" && sg!="" && sb!="" && sa=="") {
      r = int(sr);
      g = int(sg);
      b = int(sb);
      endColor = color(r, g, b);
    }
    if (sr!="" && sg!="" && sb!="" && sa!="") {
      r = int(sr);
      g = int(sg);
      b = int(sb);
      a = int(sa);
      endColor = color(r, g, b, a);
    }
      return endColor;
  }
  
  PVector setPVector(String _s){
    PVector endPVector = new PVector(0,0,0);
    int commaCounter=0;
    String sx = "";
    String sy = "";
    String sz = "";
    float x = 0;
    float y = 0;
    float z = 0;

    for (int i=0;i<_s.length();i++) {
        if (_s.charAt(i)!=char(' ') && _s.charAt(i)!=char('(') && _s.charAt(i)!=char(')')) {
          if (_s.charAt(i)==char(',')){
            commaCounter++;
          }else{
          if (commaCounter==0) sx += _s.charAt(i);
          if (commaCounter==1) sy += _s.charAt(i);
          if (commaCounter==2) sz += _s.charAt(i); 
         }
       }
     }

    if (sx!="" && sy=="" && sz=="") {
      x = float(sx);
      endPVector = new PVector(x,0);
    }
    if (sx!="" && sy!="" && sz=="") {
      x = float(sx);
      y = float(sy);
      endPVector = new PVector(x,y);
    }
    if (sx!="" && sy!="" && sz!="") {
      x = float(sx);
      y = float(sy);
      z = float(sz);
      endPVector = new PVector(x,y,z);
    }
      return endPVector;
  }
}