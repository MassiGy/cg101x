
//Camera Variables
float x, y, z;
float tx, ty, tz;
float rotX, rotY;
float mX, mY;
float xComp, zComp;
float angle;

//Movement Variables
int moveX;
int moveZ;
float vY;
boolean moveUP, moveDOWN, moveLEFT, moveRIGHT;


//Constants
int totalBoxes = 20;
int standHeight = 100;
int dragMotionConstant = 10;
int pushMotionConstant = 100;
int movementSpeed = 100;    //Bigger number = slower
float sensitivity = 25;      //Bigger number = slower
int stillBox = 100;        //Center of POV, mouse must be stillBox away from center to move
int cameraDistance = 1000;  //distance from camera to camera target





PShader outsideLightShader;
PShader insideLightShader;
PVector[] lightPos = {
  new PVector(-900, -300, -300), // light above the garden
  new PVector(-30, -30, -30), // light inside the room
};

PVector[] lightColor = {
   new PVector(255, 0, 5),
  new PVector(255, 255, 255),
 
};





PImage woodTextureImage;
PImage matteBlackTextureImage;
PImage mouseTopTextureImage;
PImage keyboardTopTextureImage;
PImage computerFrontTextureImage;
PImage screenWallpaperTextureImage;
PImage classRoomRoofTopTextureImage;
PImage classRoomFloorTextureImage;
PImage decorationFrameTextureImage1;
PImage decorationFrameTextureImage2;
PImage decorationFrameTextureImage3;
PImage doorTextureImage;
PImage soilBaseTextureImage;
PImage gardenFloorTextureImage;

PImage[] blankTexturesArray = {
  new PImage(),
  new PImage(),
  new PImage(),
  new PImage(),
  new PImage(),
  new PImage(),
};

PImage[] woodTexture = new PImage[6];
PImage[] matteBlackTexture = new PImage[6];

PVector[] blankEmissvenessArray = { // no emissivness
  new PVector(),
  new PVector(),
  new PVector(),
  new PVector(),
  new PVector(),
  new PVector(),
};

PVector[] blackEmissivenessArray = {      // for no textures
  new PVector(50, 50, 50),
  new PVector(50, 50, 50),
  new PVector(50, 50, 50),
  new PVector(50, 50, 50),
  new PVector(50, 50, 50),
  new PVector(50, 50, 50),
};

float[] defaultShininess = {    // no shininess
  100000.0,
  100000.0,
  100000.0,
  100000.0,
  100000.0,
  100000.0,
};

PVector[] blackTintsArray = {      // for no textures
  new PVector(50, 255),
  new PVector(50, 255),
  new PVector(50, 255),
  new PVector(50, 255),
  new PVector(50, 255),
  new PVector(50, 255),
  //50, 50, 50, 50, 50, 50,
};
PVector[] whiteTintsArray = {      // to preserve textures
  new PVector(255, 255),
  new PVector(255, 255),
  new PVector(255, 255),
  new PVector(255, 255),
  new PVector(255, 255),
  new PVector(255, 255),
  //255, 255, 255, 255, 255, 255,
};

boolean noTextures = false;
PShape classRoom;
PShape frontWall, backWall, rooftop, floor, leftWall, rightWall;
PShape chalkBoard, doorLeft, doorRight, lightBulb1, lightBulb2;
PShape decorationFrame1, decorationFrame2, decorationFrame3;
PShape soilBase, gardenFloor, gardenStairsStep1, gardenStairsStep2, gardenStairsStep3;

PShape[] desks;


void setup() {
  size(600, 600, P3D);
  // load shaders
  outsideLightShader=loadShader("outsideLightFragShader.glsl", "outsideLightVertShader.glsl");
  insideLightShader=loadShader("insideLightFragShader.glsl", "insideLightVertShader.glsl");

  //Camera Initialization
  x = width/2;
  y = height/2 - 200;
  y-= standHeight;
  z = (height/2.0) / tan(PI*60.0 / 360.0);
  tx = width/2;
  ty = height/2;
  tz = 0;
  rotX = 0;
  rotY = 0;
  xComp = tx - x;
  zComp = tz - z;
  angle = 0;

  //Movement Initialization
  moveX = 0;
  moveX = 0;
  moveUP = false;
  moveDOWN = false;
  moveLEFT = false;
  moveRIGHT = false;
  vY = 0;


  if (!noTextures) {
    woodTextureImage = loadImage("deskPlaneTexture.png");
    matteBlackTextureImage = loadImage("matteBlackTextureImage.png");
    mouseTopTextureImage = loadImage("mouseTopTexture.png");
    keyboardTopTextureImage=loadImage("keyboardTopTexture.png");
    computerFrontTextureImage =  loadImage("computerFrontTexture.png");
    screenWallpaperTextureImage = loadImage("screenWallpaper.png");
    classRoomRoofTopTextureImage = loadImage("classRoomRoofTopTexture.png");
    classRoomFloorTextureImage = loadImage("classRoomFloorTexture.png");
    decorationFrameTextureImage1 = loadImage("decorationImage1.png");
    decorationFrameTextureImage2 = loadImage("decorationImage2.png");
    decorationFrameTextureImage3 = loadImage("decorationImage3.png");
    doorTextureImage = loadImage("doorTexture.png");
    soilBaseTextureImage = loadImage("soilTexture.png");
    gardenFloorTextureImage = loadImage("outsideGardenTexture.png");

    for (int i = 0; i < woodTexture.length; i++)
      woodTexture[i]=woodTextureImage;


    for (int i = 0; i < matteBlackTexture.length; i++)
      matteBlackTexture[i]=matteBlackTextureImage;
  }

  //classRoom =createClassRoom(600, 450, 150) ;
  createClassRoom(600, 450, 150);
}

void draw() {
  background(230);

  translate(width/2, height/2, 0);

  cameraUpdate();
  locationUpdate();
  camera(x, y, z, tx, ty, tz, 0, 1, 0);


  ambientLight(55, 55, 55);


  for (int i=0; i<lightPos.length; i++) {
    lightSpecular(lightColor[i].x, lightColor[i].y, lightColor[i].z);
    pointLight(lightColor[i].x, lightColor[i].y, lightColor[i].z,
      lightPos[i].x, lightPos[i].y, lightPos[i].z);
  }


  fill(255);
  for (int i=0; i<lightPos.length; i++) {
    pushMatrix();
    noStroke();
    translate(lightPos[i].x, lightPos[i].y, lightPos[i].z);
    if (i==0)
      box(10, 10, 10);
    else
      box(100, 100, 100);
    popMatrix();
  }


  shader(outsideLightShader);
  shape(frontWall);
  resetShader();

  shader(insideLightShader);
  shape(chalkBoard);
  resetShader();

  shader(outsideLightShader);
  shape(backWall);
  resetShader();

  shader(insideLightShader);
  shape(decorationFrame1);
  resetShader();

  shader(outsideLightShader);
  shape(rooftop);
  resetShader();


  shader(insideLightShader);
  shape(lightBulb1);
  shape(lightBulb2);
  resetShader();


  shader(outsideLightShader);
  shape(floor);
  shape(soilBase);
  shape(gardenFloor);
  shape(gardenStairsStep1);
  shape(gardenStairsStep2);
  shape(gardenStairsStep3);
  resetShader();

  shader(outsideLightShader);
  shape(rightWall);
  resetShader();

  shader(insideLightShader);
  shape(decorationFrame2);
  shape(decorationFrame3);
  shape(doorRight);


  for (int i = 0; i < desks.length; i++) {
    shape(desks[i]);
  }
  resetShader();


  // always add the shapes that have transparency at the end
  // painters algorithm.
  shader(outsideLightShader);
  shape(leftWall);
  shape(doorLeft);
  resetShader();
  //shape(classRoom);
}


void createClassRoom(float w, float h, float t) {
  // PShape classRoom = createShape(GROUP);

  //PShape frontWall, backWall, rooftop, floor, leftWall, rightWall;
  //PShape chalkBoard, doorLeft, doorRight, lightBulb1, lightBulb2;
  //PShape decorationFrame1, decorationFrame2, decorationFrame3;
  //PShape soilBase, gardenFloor, gardenStairsStep1, gardenStairsStep2, gardenStairsStep3;

  desks = new PShape[6];
  for (int i = 0; i < desks.length; i++)
    desks[i] =  createWholeDesk(h/6, w/15, t/60);



  frontWall = createClassRoomFrontWall(h, t, 1);
  chalkBoard = createClassRoomChalkBoard(h/2, t/2, 1);

  backWall = createClassRoomBackWall(h, t, 1);
  decorationFrame1 = createClassRoomDecorationFrame(t/2, w/8, 1, decorationFrameTextureImage3);

  rooftop = createClassRoomRoofTopWall(h, w, 1);
  lightBulb1 = createClassRoomLightBulb(h/4, w/20, t/20);
  lightBulb2 = createClassRoomLightBulb(h/4, w/20, t/20);

  floor = createClassRoomFloorWall(h, w, 1);
  soilBase = createClassRoomSoilBase(h*2, w, t/6);
  gardenFloor = createClassRoomGardenFloor(h, w, 1);
  gardenStairsStep1 = createClassRoomGardenStairsStep(h/20, w/3, t/20);
  gardenStairsStep2 = createClassRoomGardenStairsStep(h/20, w/3, t/20);
  gardenStairsStep3 = createClassRoomGardenStairsStep(h/20, w/3, t/20);

  rightWall = createClassRoomRightWall(t, w, 1);
  decorationFrame2 = createClassRoomDecorationFrame(t/2, w/8, 1, decorationFrameTextureImage1);
  decorationFrame3 = createClassRoomDecorationFrame(t/2, w/8, 1, decorationFrameTextureImage2);
  doorRight = createClassRoomDoor(t/2, w/5, 1);

  leftWall = createClassRoomLeftWall(t, w, 1);
  doorLeft = createClassRoomDoor(t/2, w/5, 1);

  frontWall.translate(0, 0, -w/2);
  chalkBoard.translate(h/8, 0, -w/2+2); // +2 to avoid z-fighting

  backWall.translate(0, 0, w/2);
  decorationFrame1.rotateY(PI);
  decorationFrame1.translate(0, 0, w/2-2);

  rooftop.rotateX(HALF_PI);
  rooftop.translate(0, -t/2, 0);
  lightBulb1.rotateX(HALF_PI);
  lightBulb1.translate(0, -t/2+t/40, w/3);
  lightBulb2.rotateX(HALF_PI);
  lightBulb2.translate(0, -t/2+t/40, -w/3);


  floor.rotateX(HALF_PI);
  floor.translate(0, t/2, 0);
  soilBase.rotateX(HALF_PI);
  soilBase.translate(-h/2, t/2+t/12+2, 0);
  gardenFloor.rotateX(HALF_PI);
  gardenFloor.translate(-h, t/2, 0);
  gardenStairsStep1.rotateX(HALF_PI);
  gardenStairsStep1.translate(-1.5*h, t/2, w/6);
  gardenStairsStep2.rotateX(HALF_PI);
  gardenStairsStep2.translate(-1.5*h-h/20, t/2+t/20, w/6);
  gardenStairsStep3.rotateX(HALF_PI);
  gardenStairsStep3.translate(-1.5*h-2*h/20, t/2+2*t/20, w/6);



  // generate the desks algorithmically
  for (int i = 0; i < desks.length; i++) {
    if (i < desks.length/2)
      desks[i].translate(-(i+1)*h/6 + h/2 - w/15, t/6, 0);  // -w/15 on the X to have the first row of desks not glued to the right wall
    else
      desks[i].translate(-i*h/6 + h/2, t/6, 4*w/15);
  }



  rightWall.rotateY(HALF_PI);
  rightWall.rotateX(HALF_PI);
  rightWall.translate(w/2-t/2, 0, 0);
  decorationFrame2.rotateY(-HALF_PI);
  decorationFrame2.translate(w/2-t/2 -2, 0, 0);
  decorationFrame3.rotateY(-HALF_PI);
  decorationFrame3.translate(w/2-t/2 -2, 0, t);
  doorRight.rotateY(-HALF_PI);
  doorRight.translate(w/2-t/2 -2, t/10, -t);


  leftWall.rotateY(HALF_PI);
  leftWall.rotateX(HALF_PI);
  leftWall.translate(-w/2+t/2, 0, 0);
  doorLeft.rotateY(-HALF_PI);
  doorLeft.translate(-w/2+t/2+2, t/10, t-t/2);

  //  shape(frontWall);
  //  shape(chalkBoard);

  //  shape(backWall);
  //  shape(decorationFrame1);

  //  shape(rooftop);
  //  shape(lightBulb1);
  //  shape(lightBulb2);



  //  shape(floor);
  //  shape(soilBase);
  //  shape(gardenFloor);
  //  shape(gardenStairsStep1);
  //  shape(gardenStairsStep2);
  //  shape(gardenStairsStep3);



  //  shape(rightWall);
  //  shape(decorationFrame2);
  //  shape(decorationFrame3);
  //  shape(doorRight);

  //  for (int i = 0; i < desks.length; i++) {
  //    shape(desks[i]);
  //  }

  //  // always add the shapes that have transparency at the end
  //  // painters algorithm.
  //  shape(leftWall);
  //  shape(doorLeft);

  // return classRoom;
}

PShape createClassRoomFrontWall(float w, float h, float t) {
  PShape frontWall = createShape(GROUP);

  frontWall = createUnitaryBox(woodTexture, blankEmissvenessArray, whiteTintsArray, defaultShininess);
  frontWall.scale(w, h, t);

  return frontWall;
}

PShape createClassRoomChalkBoard(float w, float h, float t) {
  PShape chalkBoard = createShape(GROUP);

  PVector[] tints = {
    new PVector(120, 255),
    new PVector(120, 255),
    new PVector(120, 255),
    new PVector(120, 255),
    new PVector(120, 255),
    new PVector(120, 255),
    //120, 120, 120, 120, 120, 120
  };

  chalkBoard = createUnitaryBox(matteBlackTexture, blankEmissvenessArray, tints, defaultShininess);
  chalkBoard.scale(w, h, t);
  return chalkBoard;
}

PShape createClassRoomBackWall(float w, float h, float t) {
  PShape backWall = createShape(GROUP);

  backWall = createUnitaryBox(woodTexture, blankEmissvenessArray, whiteTintsArray, defaultShininess);
  backWall.scale(w, h, t);

  return backWall;
}


PShape createClassRoomRoofTopWall(float w, float h, float t) {
  PShape rooftop = createShape(GROUP);

  PImage[] rooftopWallTexture = {
    classRoomRoofTopTextureImage,
    classRoomRoofTopTextureImage,
    classRoomRoofTopTextureImage,
    classRoomRoofTopTextureImage,
    classRoomRoofTopTextureImage,
    classRoomRoofTopTextureImage,
  };

  rooftop = createUnitaryBox(rooftopWallTexture, blankEmissvenessArray, whiteTintsArray, defaultShininess);
  rooftop.scale(w, h, t);

  return rooftop;
}

PShape createClassRoomLightBulb(float w, float h, float t) {
  PShape lightbulb = createShape(GROUP);

  lightbulb = createUnitaryBox(blankTexturesArray, blankEmissvenessArray, whiteTintsArray, defaultShininess);
  lightbulb.scale(w, h, t);

  return lightbulb;
}



PShape createClassRoomFloorWall(float w, float h, float t) {
  PShape floor = createShape(GROUP);

  PImage[] floorWallTexture = {
    classRoomFloorTextureImage,
    classRoomFloorTextureImage,
    classRoomFloorTextureImage,
    classRoomFloorTextureImage,
    classRoomFloorTextureImage,
    classRoomFloorTextureImage,
  };

  floor = createUnitaryBox(floorWallTexture, blankEmissvenessArray, whiteTintsArray, defaultShininess);
  floor.scale(w, h, t);

  return floor;
}


PShape createClassRoomSoilBase(float w, float h, float t) {
  PShape soilBase = createShape(GROUP);

  PImage[] soilBaseTexture = {
    soilBaseTextureImage,
    soilBaseTextureImage,
    soilBaseTextureImage,
    soilBaseTextureImage,
    soilBaseTextureImage,
    soilBaseTextureImage,
  };

  soilBase = createUnitaryBox(soilBaseTexture, blankEmissvenessArray, whiteTintsArray, defaultShininess);
  soilBase.scale(w, h, t);

  return soilBase;
}


PShape createClassRoomGardenFloor(float w, float h, float t) {
  PShape gardenFloor = createShape(GROUP);

  PImage[] gardenFloorTexture = {
    gardenFloorTextureImage,
    gardenFloorTextureImage,
    gardenFloorTextureImage,
    gardenFloorTextureImage,
    gardenFloorTextureImage,
    gardenFloorTextureImage,
  };

  gardenFloor = createUnitaryBox(gardenFloorTexture, blankEmissvenessArray, whiteTintsArray, defaultShininess);
  gardenFloor.scale(w, h, t);

  return gardenFloor;
}

PShape createClassRoomGardenStairsStep(float w, float h, float t) {
  PShape stairsStep = createShape(GROUP);

  PImage[] stairsStepTexture = {
    classRoomFloorTextureImage,
    classRoomFloorTextureImage,
    classRoomFloorTextureImage,
    classRoomFloorTextureImage,
    classRoomFloorTextureImage,
    classRoomFloorTextureImage,
  };
  PVector[] tints = {    // make the texture slightly darker
    new PVector(191, 255),
    new PVector(191, 255),
    new PVector(191, 255),
    new PVector(191, 255),
    new PVector(191, 255),
    new PVector(191, 255),
    //191, 191, 191, 191, 191, 191
  };

  stairsStep = createUnitaryBox(stairsStepTexture, blankEmissvenessArray, tints, defaultShininess);
  stairsStep.scale(w, h, t);

  return stairsStep;
}



PShape createClassRoomRightWall(float w, float h, float t) {
  PShape rightWall = createShape(GROUP);

  rightWall = createUnitaryBox(woodTexture, blankEmissvenessArray, whiteTintsArray, defaultShininess);
  rightWall.scale(w, h, t);

  return rightWall;
}

PShape createClassRoomDoor(float w, float h, float t) {
  PShape door = createShape(GROUP);

  PImage[] doorTexture = {
    doorTextureImage,
    doorTextureImage,
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
  };
  PVector[] tints = {
    new PVector(255, 255),
    new PVector(255, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    //255, 255, 50, 50, 50, 50
  };

  door = createUnitaryBox(doorTexture, blankEmissvenessArray, tints, defaultShininess);
  door.scale(w, h, t);

  return door;
}


PShape createClassRoomLeftWall(float w, float h, float t) {
  PShape leftWall = createShape(GROUP);


  // wall partial that is  the support for the door.
  PShape leftWallPartial1 = createUnitaryBox(woodTexture, blankEmissvenessArray, whiteTintsArray, defaultShininess);
  leftWallPartial1.scale(w, h/2, t);

  // wall partial that is at start of the room (close to the chalk board)
  PShape leftWallPartial2 = createUnitaryBox(woodTexture, blankEmissvenessArray, whiteTintsArray, defaultShininess);
  leftWallPartial2.scale(w, h/6, t);

  // Partail 3 and 4 are the small wall parts ontop and on the buttom of the window
  PShape leftWallPartial3 = createUnitaryBox(woodTexture, blankEmissvenessArray, whiteTintsArray, defaultShininess);
  leftWallPartial3.scale(w/4, 2*h/6, t);

  PShape leftWallPartial4 = createUnitaryBox(woodTexture, blankEmissvenessArray, whiteTintsArray, defaultShininess);
  leftWallPartial4.scale(w/4, 2*h/6, t);

  PVector[] windowTints = {
    new PVector(153, 50),
    new PVector(153, 50),
    new PVector(153, 50),
    new PVector(153, 50),
    new PVector(153, 50),
    new PVector(153, 50),
  };
  PShape leftWallWindow = createUnitaryBox(blankTexturesArray, blankEmissvenessArray, windowTints, defaultShininess);
  leftWallWindow.scale(w/2, 2*h/6, t);


  leftWallPartial1.translate(0, h/2*0.5, 0);

  leftWallPartial3.translate(w/4+w/8, -h/6, 0);
  leftWallWindow.translate(0, -h/6, 0);
  leftWallPartial4.translate(-w/4-w/8, -h/6, 0);

  leftWallPartial2.translate(0, -2*h/6-h/12, 0);


  leftWall.addChild(leftWallPartial1);
  leftWall.addChild(leftWallPartial2);
  leftWall.addChild(leftWallPartial3);
  leftWall.addChild(leftWallPartial4);
  leftWall.addChild(leftWallWindow);


  return leftWall;
}



PShape createClassRoomDecorationFrame(float w, float h, float t, PImage texture) {
  PShape frame = createShape(GROUP);

  PImage[] frameTexture = {
    texture,
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
  };

  frame = createUnitaryBox(frameTexture, blankEmissvenessArray, whiteTintsArray, defaultShininess);
  frame.scale(w, h, t);

  return frame;
}


PShape createWholeDesk(float w, float h, float t) {
  PShape wholeDesk = createShape(GROUP);

  PShape screen;
  PShape computer;
  PShape keyboard;
  PShape mouse;
  PShape desk;
  PShape chair;

  screen = createScreenShape(w/3, h/3, t/3);

  computer = createComputerShape(w/8, h/4, t*8);
  computer.translate(w/3, h/8.5, 0);

  keyboard = createKeyboardShape(w/5, h/6, t/3);
  keyboard.translate(0, h/4, w/5);

  mouse = createMouseShape(w/25, h/12, t/5);
  mouse.translate(w/5, h/4, w/5);

  desk = createDeskShape(w, h, t);
  desk.translate(0, h/3.5, 0);

  chair = createChairShape(w/2.5, h/1.5, t);
  chair.rotateY(PI);
  chair.translate(0, h/4, h/1.5);

  wholeDesk.addChild(screen);
  wholeDesk.addChild(computer);
  wholeDesk.addChild(keyboard);
  wholeDesk.addChild(mouse);
  wholeDesk.addChild(chair);
  wholeDesk.addChild(desk);

  return wholeDesk;
}


PShape createChairShape(float w, float h, float t) {
  PShape chair = createShape(GROUP);

  PShape backRest = createUnitaryBox(woodTexture, blankEmissvenessArray, whiteTintsArray, defaultShininess);
  PShape buttom =createUnitaryBox(woodTexture, blankEmissvenessArray, whiteTintsArray, defaultShininess);

  backRest.scale(w, h, t);
  buttom.scale(w, h, t);
  buttom.rotateX(HALF_PI);
  buttom.translate(0, w/2, h/2);


  PShape[] legs = new PShape[4];

  for (int i = 0; i < legs.length; i++) {
    legs[i] = createUnitaryBox(matteBlackTexture, blankEmissvenessArray, blackTintsArray, defaultShininess);

    legs[i].scale(w/10, h, t*2);

    if (i%2==0)
      if (i<legs.length/2)
        legs[i].translate(-w/2, h, 0);
      else
        legs[i].translate(-w/2, h, h);
    else
      if (i<legs.length/2)
        legs[i].translate(w/2, h, 0);
      else
        legs[i].translate(w/2, h, h);
  }


  chair.addChild(backRest);
  chair.addChild(buttom);
  for (int i = 0; i < legs.length; i++) {
    chair.addChild(legs[i]);
  }
  return chair;
}


PShape createDeskShape(float w, float h, float t) {
  PShape desk = createShape(GROUP);

  PShape deskPlane = createUnitaryBox(woodTexture, blankEmissvenessArray, whiteTintsArray, defaultShininess);
  deskPlane.scale(w, h, t);


  PShape[] legs = new PShape[4];

  for (int i = 0; i < legs.length; i++) {
    legs[i] = createUnitaryBox(matteBlackTexture, blankEmissvenessArray, blackTintsArray, defaultShininess);

    legs[i].scale(w/20, h, t);
    legs[i].rotateX(-HALF_PI);

    if (i%2==0)
      if (i<legs.length/2)
        legs[i].translate(-w/2, -h/2, h/2);
      else
        legs[i].translate(-w/2, h/2, h/2);
    else
      if (i<legs.length/2)
        legs[i].translate(w/2, -h/2, h/2);
      else
        legs[i].translate(w/2, h/2, h/2);
  }

  desk.addChild(deskPlane);
  for (int i = 0; i < legs.length; i++) {
    desk.addChild(legs[i]);
  }

  desk.rotateX(-HALF_PI);
  return desk;
}

PShape createMouseShape(float w, float h, float t) {
  PShape mouse;

  PImage[] mouseTexture = {
    mouseTopTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,

  };
  PVector[] tints = {
    new PVector(191, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    //191,50, 50, 50, 50, 50,
  };
  mouse = createUnitaryBox(mouseTexture, blankEmissvenessArray, tints, defaultShininess);
  mouse.scale(w, h, t);
  mouse.rotateX(HALF_PI);

  return mouse;
}

PShape createKeyboardShape(float w, float h, float t) {
  PShape keyboard;

  PImage[] keyboardTexture = {
    keyboardTopTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,
  };
  PVector[] tints = {
    new PVector(255, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    //255,50, 50, 50, 50, 50,
  };
  keyboard = createUnitaryBox(keyboardTexture, blankEmissvenessArray, tints, defaultShininess);
  keyboard.scale(w, h, t);
  keyboard.rotateX(HALF_PI);

  return keyboard;
}


PShape createComputerShape(float w, float h, float t) {
  PShape computer;

  PImage[] computerTexture = {
    computerFrontTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,
  };
  PVector[] tints = {
    new PVector(255, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    //255,50, 50, 50, 50, 50,
  };
  computer = createUnitaryBox(computerTexture, blankEmissvenessArray, tints, defaultShininess);
  computer.scale(w, h, t);

  return computer;
}


PShape createScreenShape(float w, float h, float t) {
  PShape screen = createShape(GROUP);

  PVector[] screenEmissveness = {
    new PVector(255, 255, 255),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] screenPlaneTexture = {
    screenWallpaperTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,
    matteBlackTextureImage,
  };

  PVector[] screenTints = {
    new PVector(255, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    new PVector(50, 255),
    //255,50, 50, 50, 50, 50,
  };

  PShape screenPlane = createUnitaryBox(screenPlaneTexture, screenEmissveness, screenTints, defaultShininess);
  screenPlane.scale(w, h, t);

  PShape leg = createUnitaryBox(matteBlackTexture, blankEmissvenessArray, blackTintsArray, defaultShininess);

  leg.scale(w/10, h/2, t);
  leg.translate(0, h/2, -t);


  PShape buttomRestPlane = createUnitaryBox(matteBlackTexture, blankEmissvenessArray, blackTintsArray, defaultShininess);

  buttomRestPlane.scale(w/3, h/2, t);
  buttomRestPlane.rotateX(HALF_PI);

  buttomRestPlane.translate(0, h-h*.3, h/(4*10));

  screen.addChild(screenPlane);
  screen.addChild(leg);
  screen.addChild(buttomRestPlane);

  return screen;
}


PShape createUnitaryBox(PImage[] facesTextures, PVector[] facesEmissiveness, PVector[] facesTints, float[] facesShininess) {
  assert(facesTextures.length == 6);
  assert(facesEmissiveness.length == 6);
  assert(facesTints.length == 6);
  assert(facesShininess.length == 6);

  PShape box = createShape(GROUP);

  PShape[] faces = {
    createShape(),
    createShape(),
    createShape(),
    createShape(),
    createShape(),
    createShape(),
  };

  float c = 0.5;

  // normals (8 of them),
  PVector _c_cc = (new PVector(-c, -c, c)).normalize(); // for the vertex(-c, -c,c)
  PVector _ccc = (new PVector(-c, c, c)).normalize();
  PVector ccc = (new PVector(c, c, c)).normalize();
  PVector c_cc = (new PVector(c, -c, c)).normalize();
  PVector _c_c_c = (new PVector(-c, -c, -c)).normalize(); // for the vertex(-c, -c,c)
  PVector _cc_c = (new PVector(-c, c, -c)).normalize();
  PVector cc_c = (new PVector(c, c, -c)).normalize();
  PVector c_c_c = (new PVector(c, -c, -c)).normalize();

  // AVANT
  faces[0].beginShape();
  faces[0].noStroke();
  faces[0].textureMode(NORMAL);
  faces[0].texture(facesTextures[0]);
  faces[0].tint(facesTints[0].x, facesTints[0].y);
  faces[0].emissive(facesEmissiveness[0].x, facesEmissiveness[0].y, facesEmissiveness[0].z);
  faces[0].shininess(facesShininess[0]);

  faces[0].normal(_c_cc.x, _c_cc.y, _c_cc.z  );
  faces[0].vertex(-c, -c, c, 0, 0);

  faces[0].normal(_ccc.x, _ccc.y, _ccc.z  );
  faces[0].vertex(-c, c, c, 0, 1);

  faces[0].normal(ccc.x, ccc.y, ccc.z  );
  faces[0].vertex(c, c, c, 1, 1);

  faces[0].normal(c_cc.x, c_cc.y, c_cc.z  );
  faces[0].vertex(c, -c, c, 1, 0);
  faces[0].endShape();


  // FOND
  faces[1].beginShape();
  faces[1].noStroke();
  faces[1].textureMode(NORMAL);
  faces[1].texture(facesTextures[1]);
  faces[1].tint(facesTints[1].x, facesTints[1].y);
  faces[1].emissive(facesEmissiveness[1].x, facesEmissiveness[1].y, facesEmissiveness[1].z);
  faces[1].shininess(facesShininess[1]);

  faces[1].normal(_c_c_c.x, _c_c_c.y, _c_c_c.z  );
  faces[1].vertex(-c, -c, -c, 0, 0);

  faces[1].normal(_cc_c.x, _cc_c.y, _cc_c.z  );
  faces[1].vertex(-c, c, -c, 0, 1);

  faces[1].normal(cc_c.x, cc_c.y, cc_c.z  );
  faces[1].vertex(c, c, -c, 1, 1);

  faces[1].normal(c_c_c.x, c_c_c.y, c_c_c.z  );
  faces[1].vertex(c, -c, -c, 1, 0);

  faces[1].endShape();

  // HAUT
  faces[2].beginShape();
  faces[2].noStroke();
  faces[2].textureMode(NORMAL);
  faces[2].texture(facesTextures[2]);
  faces[2].tint(facesTints[2].x, facesTints[2].y);
  faces[2].emissive(facesEmissiveness[2].x, facesEmissiveness[2].y, facesEmissiveness[2].z);
  faces[2].shininess(facesShininess[2]);

  faces[2].normal(_c_cc.x, _c_cc.y, _c_cc.z  );
  faces[2].vertex(-c, -c, c, 0, 0);

  faces[2].normal(c_cc.x, c_cc.y, c_cc.z  );
  faces[2].vertex(c, -c, c, 1, 0);

  faces[2].normal(c_c_c.x, c_c_c.y, c_c_c.z  );
  faces[2].vertex(c, -c, -c, 1, 1);

  faces[2].normal(_c_c_c.x, _c_c_c.y, _c_c_c.z  );
  faces[2].vertex(-c, -c, -c, 0, 1);

  faces[2].endShape();


  // GAUCHE
  faces[3].beginShape();
  faces[3].noStroke();
  faces[3].textureMode(NORMAL);
  faces[3].texture(facesTextures[3]);
  faces[3].tint(facesTints[3].x, facesTints[3].y);
  faces[3].emissive(facesEmissiveness[3].x, facesEmissiveness[3].y, facesEmissiveness[3].z);
  faces[3].shininess(facesShininess[3]);

  faces[3].normal(_c_cc.x, _c_cc.y, _c_cc.z);
  faces[3].vertex(-c, -c, c, 1, 1);

  faces[3].normal(_c_c_c.x, _c_c_c.y, _c_c_c.z);
  faces[3].vertex(-c, -c, -c, 0, 1);

  faces[3].normal(_cc_c.x, _cc_c.y, _cc_c.z);
  faces[3].vertex(-c, c, -c, 0, 0);

  faces[3].normal(_ccc.x, _ccc.y, _ccc.z);
  faces[3].vertex(-c, c, c, 1, 0);

  faces[3].endShape();

  // DROITE
  faces[4].beginShape();
  faces[4].noStroke();
  faces[4].textureMode(NORMAL);
  faces[4].texture(facesTextures[4]);
  faces[4].tint(facesTints[4].x, facesTints[4].y);
  faces[4].emissive(facesEmissiveness[4].x, facesEmissiveness[4].y, facesEmissiveness[4].z);
  faces[4].shininess(facesShininess[4]);

  faces[4].normal(c_cc.x, c_cc.y, c_cc.z);
  faces[4].vertex(c, -c, c, 1, 1);

  faces[4].normal(c_c_c.x, c_c_c.y, c_c_c.z);
  faces[4].vertex(c, -c, -c, 0, 1);

  faces[4].normal(cc_c.x, cc_c.y, cc_c.z);
  faces[4].vertex(c, c, -c, 0, 0);

  faces[4].normal(ccc.x, ccc.y, ccc.z);
  faces[4].vertex(c, c, c, 1, 0);

  faces[4].endShape();

  // BAS
  faces[5].beginShape();
  faces[5].noStroke();
  faces[5].textureMode(NORMAL);
  faces[5].texture(facesTextures[5]);
  faces[5].tint(facesTints[5].x, facesTints[5].y);
  faces[5].emissive(facesEmissiveness[5].x, facesEmissiveness[5].y, facesEmissiveness[5].z);
  faces[5].shininess(facesShininess[5]);

  faces[5].normal(_ccc.x, _ccc.y, _ccc.z);
  faces[5].vertex(-c, c, c, 0, 0);

  faces[5].normal(ccc.x, ccc.y, ccc.z);
  faces[5].vertex(c, c, c, 1, 0);

  faces[5].normal(cc_c.x, cc_c.y, cc_c.z);
  faces[5].vertex(c, c, -c, 1, 1);

  faces[5].normal(_cc_c.x, _cc_c.y, _cc_c.z);
  faces[5].vertex(-c, c, -c, 0, 1);

  faces[5].endShape();



  for (int i = 0; i < faces.length; i++) {
    box.addChild(faces[i]);
  }
  return box;
}


public void cameraUpdate() {

  int diffX = mouseX - width/2;
  int diffY = mouseY - width/2;

  if (abs(diffX) > stillBox) {
    xComp = tx - x;
    zComp = tz - z;
    angle = correctAngle(xComp, zComp);

    angle+= diffX/(sensitivity*10);

    if (angle < 0)
      angle += 360;
    else if (angle >= 360)
      angle -= 360;

    float newXComp = cameraDistance * sin(radians(angle));
    float newZComp = cameraDistance * cos(radians(angle));

    tx = newXComp + x;
    tz = -newZComp + z;
  }

  if (abs(diffY) > stillBox)
    ty += diffY/(sensitivity/1.5);
}


public void locationUpdate() {

  if (moveUP) {
    z += zComp/movementSpeed;
    tz+= zComp/movementSpeed;
    x += xComp/movementSpeed;
    tx+= xComp/movementSpeed;
  } else if (moveDOWN) {
    z -= zComp/movementSpeed;
    tz-= zComp/movementSpeed;
    x -= xComp/movementSpeed;
    tx-= xComp/movementSpeed;
  }
  if (moveRIGHT) {
    z += xComp/movementSpeed;
    tz+= xComp/movementSpeed;
    x -= zComp/movementSpeed;
    tx-= zComp/movementSpeed;
  }
  if (moveLEFT) {
    z -= xComp/movementSpeed;
    tz-= xComp/movementSpeed;
    x += zComp/movementSpeed;
    tx+= zComp/movementSpeed;
  }
}

public void keyPressed() {
  if (keyCode == UP) {
    moveZ = -10;
    moveUP = true;
  } else if (keyCode == DOWN) {
    moveZ = 10;
    moveDOWN = true;
  } else if (keyCode == LEFT) {
    moveX = -10;
    moveLEFT = true;
  } else if (keyCode == RIGHT) {
    moveX = 10;
    moveRIGHT = true;
  }
}

public void keyReleased() {
  if (keyCode == UP) {
    moveUP = false;
    moveZ = 0;
  } else if (keyCode == DOWN) {
    moveDOWN = false;
    moveZ = 0;
  } else if (keyCode == LEFT) {
    moveLEFT = false;
    moveX = 0;
  } else if (keyCode == RIGHT) {
    moveRIGHT = false;
    moveX = 0;
  }
}

// black magic
public float correctAngle(float xc, float zc) {
  float newAngle = -degrees(atan(xc/zc));
  if (xComp > 0 && zComp > 0)
    newAngle = (90 + newAngle)+90;
  else if (xComp < 0 && zComp > 0)
    newAngle = newAngle + 180;
  else if (xComp < 0 && zComp < 0)
    newAngle = (90+ newAngle) + 270;
  return newAngle;
}
